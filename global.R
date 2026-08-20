library(tidyverse)
library(readxl)
library(DT)
library(plotly)
library(visNetwork)
library(bslib)
library(bsicons)
library(patchwork)
library(rlang)
library(leaflet)

# Paths
data_dir <- "data"

# Actor aggregate data
dta_agg <- read_csv(
  file.path(data_dir, "dta_agg.csv"),
  show_col_types = FALSE
) %>%
  select(-1)

# UN development categories
un_countries <- read_csv(
  file.path(data_dir, "un_countries.csv"),
  quote = "", show_col_types = FALSE
) %>%
  mutate(across(everything(), ~ gsub('"', '', .x))) %>%
  rename(Parent_Code = `"Parent_Code`, actor = `Child_Label"`, cat = Parent_Label) %>%
  filter(cat %in% c(
    "Developed economies", "Developing economies",
    "LDCs (Least developed countries)",
    "LLDCs (Landlocked developing countries)",
    "SIDS (Small island developing States) (UN-OHRLLS)"
  )) %>%
  mutate(across(everything(), tolower)) %>%
  distinct(actor, cat) %>%
  mutate(value = 1) %>%
  pivot_wider(names_from = cat, values_from = value, values_fill = 0) %>%
  rename(
    developed  = "developed economies",
    developing = "developing economies",
    ldcs       = "ldcs (least developed countries)",
    lldcs      = "lldcs (landlocked developing countries)",
    sids       = "sids (small island developing states) (un-ohrlls)"
  ) %>%
  mutate(actor = case_when(
    actor == "micronesia (federated states of)" ~ "federated states of micronesia",
    actor == "cote d'ivoire"                    ~ "ivory coast",
    actor == "netherlands (kingdom of the)"     ~ "netherlands",
    actor == "qatar"                            ~ "qatar",
    actor == "russian federation"               ~ "russia",
    actor == "united republic of tanzania"      ~ "tanzania",
    actor == "united kingdom"                   ~ "uk",
    actor == "united states"                    ~ "usa",
    TRUE                                        ~ actor
  ))

dta_agg <- dta_agg %>% left_join(un_countries, by = "actor")

# Network data
raw_nodes <- read_csv(file.path(data_dir, "nodesV2.csv"), show_col_types = FALSE)
raw_edges <- read_csv(file.path(data_dir, "edgesV2.csv"), show_col_types = FALSE)

# Correctly-cased display names from Gephi labels (WWF, DSCC, IUCN, etc.)
# Used in all four actor selectize dropdowns.
actor_label_lookup <- raw_nodes %>%
  filter(type == "actor") %>%
  transmute(actor = str_replace_all(id, "_", " "), label) %>%
  deframe()

actor_choices <- local({
  actors <- sort(unique(dta_agg$actor))
  labels <- actor_label_lookup[actors]
  labels[is.na(labels)] <- str_to_title(actors[is.na(labels)])
  c("Select actor" = "", setNames(actors, labels))
})

# Vision pole coordinates: roughly balanced triangle (middle ground between original and equilateral)
# EC left, MR right, SI bottom
pole_coords <- tibble(
  id = c("mr",  "si",  "ec"),
  px = c( 600,    0,  -600),
  py = c(   0,  720,     0)
)

# Actor positions: barycentric weighted by edge weights to each vision pole, plus jitter
set.seed(42)
actor_pos <- raw_edges %>%
  filter(target %in% c("mr", "si", "ec")) %>%
  left_join(pole_coords %>% rename(target = id), by = "target") %>%
  group_by(id = source) %>%
  summarise(
    x = sum(weight * px) + runif(1, -30, 30),
    y = sum(weight * py) + runif(1, -30, 30),
    .groups = "drop"
  )

# Two-phase layout nudge for actor nodes (vision poles untouched):
#   Phase 1 (min_dist > 0): push overlapping pairs apart until all gaps >= min_dist
#   Phase 2 (jitter > 0):   add an independent random offset to each actor node
# Both at 0 is an exact no-op: returns raw barycentric positions.
nudge_apart <- function(nodes, min_dist = 50, jitter = 35, iters = 120) {
  if (min_dist <= 0 && jitter <= 0) return(nodes)
  ai <- which(nodes$type != "vision")
  x  <- nodes$x
  y  <- nodes$y

  if (min_dist > 0) {
    for (it in seq_len(iters)) {
      moved <- FALSE
      n <- length(ai)
      for (ii in seq_len(n - 1)) {
        for (jj in (ii + 1):n) {
          i  <- ai[ii]; j <- ai[jj]
          dx <- x[i] - x[j]; dy <- y[i] - y[j]
          d  <- sqrt(dx^2 + dy^2)
          if (d < min_dist) {
            if (d < 1e-6) { dx <- cos(it * 0.7); dy <- sin(it * 0.7); d <- 1 }
            push <- (min_dist - d) / 2
            x[i] <- x[i] + push * dx / d;  y[i] <- y[i] + push * dy / d
            x[j] <- x[j] - push * dx / d;  y[j] <- y[j] - push * dy / d
            moved <- TRUE
          }
        }
      }
      if (!moved) break
    }
  }

  if (jitter > 0) {
    x[ai] <- x[ai] + runif(length(ai), -jitter, jitter)
    y[ai] <- y[ai] + runif(length(ai), -jitter, jitter)
  }

  nodes$x <- x
  nodes$y <- y
  nodes
}

net_nodes <- raw_nodes %>%
  filter(id != "international_tribunal_for_the_law_of_the_sea") %>%
  left_join(pole_coords,                           by = "id") %>%
  left_join(actor_pos %>% rename(ax = x, ay = y), by = "id") %>%
  # Join actor type and vision scores from dta_agg for shape encoding and hover tooltips
  left_join(
    dta_agg %>% transmute(
      id = str_replace_all(actor, " ", "_"),
      actor_type_eh2, mean_mr2, mean_si2, mean_ec2
    ),
    by = "id"
  ) %>%
  mutate(
    x = if_else(type == "vision", px, ax),
    y = if_else(type == "vision", py, ay)
  ) %>%
  select(-px, -py, -ax, -ay) %>%
  mutate(
    size  = if_else(type == "vision", 36, 14),
    # Shape directly from actor_type_eh2.
    # Only manual override: "enterprise" (Interim Director General) -> diamond (ISA).
    shape = case_when(
      type == "vision"                                            ~ "diamond",
      actor_type_eh2 == "member state"                           ~ "dot",
      actor_type_eh2 == "regional group"                         ~ "hexagon",
      actor_type_eh2 == "observer ngo"                           ~ "square",
      actor_type_eh2 == "observer igo"                           ~ "triangle",
      actor_type_eh2 %in% c("isa", "enterprise")                 ~ "diamond",
      actor_type_eh2 == "observer state"                         ~ "triangleDown",
      TRUE                                                        ~ "triangle"
    ),
    # Muted cluster colours (same palette as 3D scatter)
    color = case_when(
      type == "vision" ~ "#FFFFFF",
      cluster5 == 3    ~ "#6DB589",  # Env. Custodian     (ec=0.91)
      cluster5 == 4    ~ "#5BAAB6",  # MR + Env. Cust.   (ec=0.72)
      cluster5 == 2    ~ "#8A7ABF",  # Mining Reg. + EC  (ec=0.60)
      cluster5 == 1    ~ "#CC8A52",  # Mining Regulator  (ec=0.33)
      TRUE             ~ "#999999"
    ),
    font.size        = if_else(type == "vision", 18, 10),
    font.color       = "#111111",
    font.strokeWidth = 2,
    font.strokeColor = "#ffffff",
    title = case_when(
      type == "vision" ~ label,
      TRUE ~ paste0(
        "<b>", label, "</b><br>",
        "Mining Reg.: <b>", round(mean_mr2, 3), "</b><br>",
        "MSR Inst.: <b>",   round(mean_si2, 3), "</b><br>",
        "Env. Cust.: <b>",  round(mean_ec2, 3), "</b>"
      )
    )
  ) %>%
  nudge_apart(min_dist = 45, iters = 120)

# Apply manual position overrides saved from node_editor.R (if present)
.manual_pos_file <- "node_positions_manual.csv"
if (file.exists(.manual_pos_file)) {
  .manual_pos <- read_csv(.manual_pos_file, show_col_types = FALSE)
  net_nodes <- net_nodes %>%
    left_join(.manual_pos %>% select(id, x_m = x, y_m = y), by = "id") %>%
    mutate(x = coalesce(x_m, x), y = coalesce(y_m, y)) %>%
    select(-x_m, -y_m)
  message("global.R: applied manual node positions for ",
          sum(!is.na(.manual_pos$x)), " nodes")
  rm(.manual_pos, .manual_pos_file)
}

net_edges <- raw_edges %>%
  filter(target %in% c("mr", "si", "ec"), weight >= 0.05) %>%
  rename(from = source, to = target) %>%
  mutate(
    width = weight * 1.8,
    color = "rgba(0,0,0,0.07)"
  )

# GPT model output (dta_resultsV2 already contains date, time, meeting)
gpt_results <- read_csv(
  file.path(data_dir, "dta_resultsV2.csv"),
  show_col_types = FALSE
) %>%
  filter(actor %in% dta_agg$actor) %>%
  filter(!(mining_regulator == 0 & science_institution == 0 & environmental_custodian == 0)) %>%
  select(id_statement, actor,
         statement    = comment_obs,
         mining_regulator, science_institution, environmental_custodian,
         explanation, date, time, meeting) %>%
  mutate(
    actor = str_to_title(actor),
    meeting = case_when(
      meeting == "30th part i council"   ~ "Council (30th Session Part I)",
      meeting == "30th part ii council"  ~ "Council (30th Session Part II)",
      meeting == "30th part ii assembly" ~ "Assembly (30th Session Part II)",
      TRUE                               ~ str_to_title(meeting)
    )
  )

# Scale and vision definitions
understandings <- read_excel(file.path(data_dir, "understandings.xlsx"))
scale_text      <- understandings$scale_understanding[1]
vision_text     <- understandings$vision_understanding[1]

# Colour palettes
pal_mr <- "#B63F7B"
pal_si <- "#3F9BA8"
pal_ec <- "#4BAF67"

vision_colours <- c(
  "Mining Regulator"        = pal_mr,
  "MSR Institution"         = pal_si,
  "Environmental Custodian" = pal_ec
)

# Helper: grouped bar chart data
# data argument defaults to full dataset; pass a filtered reactive to scope comparisons
make_group_data <- function(grouping, data = dta_agg) {
  switch(grouping,

    "Moratorium / Sponsor" = data %>%
      filter(actor_type_eh2 == "member state" | actor == "african group") %>%
      group_by(group = morasponsor) %>%
      summarise(across(c(mean_mr2, mean_si2, mean_ec2), \(x) mean(x, na.rm = TRUE)),
                n = n(), .groups = "drop") %>%
      mutate(group = factor(group,
        levels = c("sponsor", "moratorium/pp", "both", "neither"),
        labels = c("Sponsor", "Moratorium / PP", "Both", "Neither"))),

    "Development Status" = data %>%
      pivot_longer(c(developed, developing, ldcs, lldcs, sids),
                   names_to = "group", values_to = "has") %>%
      filter(has == 1) %>%
      group_by(group) %>%
      summarise(across(c(mean_mr2, mean_si2, mean_ec2), \(x) mean(x, na.rm = TRUE)),
                n = n(), .groups = "drop") %>%
      mutate(group = factor(group,
        levels = c("developed", "developing", "ldcs", "lldcs", "sids"),
        labels = c("Developed", "Developing", "LDCs", "LLDCs", "SIDS"))),

    "SIDS: Sponsor vs Not" = data %>%
      filter(!is.na(sids), sids == 1) %>%
      group_by(group = sponsorstate) %>%
      summarise(across(c(mean_mr2, mean_si2, mean_ec2), \(x) mean(x, na.rm = TRUE)),
                n = n(), .groups = "drop") %>%
      mutate(group = factor(group, levels = c(1, 0),
                            labels = c("SIDS: Sponsor", "SIDS: Not sponsor"))),

    "Council Membership" = data %>%
      filter(actor_type_eh2 == "member state" | actor == "african group") %>%
      mutate(council_member = if_else(actor == "african group", 1, council_member)) %>%
      group_by(group = council_member) %>%
      summarise(across(c(mean_mr2, mean_si2, mean_ec2), \(x) mean(x, na.rm = TRUE)),
                n = n(), .groups = "drop") %>%
      mutate(group = factor(group, levels = c(1, 0),
                            labels = c("Council member", "Not Council member"))),

    "Regional Group" = data %>%
      filter(actor_type_eh2 == "member state" | actor == "african group") %>%
      group_by(group = regional_group) %>%
      summarise(across(c(mean_mr2, mean_si2, mean_ec2), \(x) mean(x, na.rm = TRUE)),
                n = n(), .groups = "drop") %>%
      mutate(group = factor(group,
        levels = c("african group", "latin american caribbean group",
                   "western europe and other states group",
                   "eastern europe group", "asia pacific group"),
        labels = c("African Group", "Latin American\nCaribbean Group",
                   "Western Europe\n& Other States",
                   "Eastern Europe Group", "Asia Pacific Group"))),

    "Actor Type" = data %>%
      filter(actor_type_eh2 %in% c("member state", "observer ngo", "isa"),
             !actor %in% c("secretariat", "chair of finance committee",
                           "deputy to the secretary general", "legal counsel",
                           "master of ceremony", "president of council",
                           "head of security", "council",
                           "chair legal and technical commission")) %>%
      mutate(actor_type_eh2 = if_else(actor == "african group",
                                      "member state", actor_type_eh2)) %>%
      group_by(group = actor_type_eh2) %>%
      summarise(across(c(mean_mr2, mean_si2, mean_ec2), \(x) mean(x, na.rm = TRUE)),
                n = n(), .groups = "drop") %>%
      mutate(group = factor(group,
        levels = c("member state", "observer ngo", "isa"),
        labels = c("Member State", "Observer NGO", "ISA SG")))
  )
}


# ── Bar chart helpers (ported from paper_code/descriptive.R) ==================

col_mr  <- "#CC8A52"
col_msr <- "#5BAAB6"
col_ec  <- "#6DB589"

theme_bar <- theme_minimal(base_size = 10) +
  theme(
    panel.grid.major.x = element_blank(),
    panel.grid.minor   = element_blank(),
    axis.title.x       = element_blank(),
    axis.ticks.x       = element_blank(),
    plot.title         = element_text(face = "bold", size = 10, hjust = 0.5),
    legend.position    = "none"
  )

# Triple bar chart: 3 side-by-side panels (MR, MSR inst., EC).
# return_list = TRUE: list of 3 ggplot objects (for combining with spacer).
# return_list = FALSE (default): assembled patchwork.
plot_all_visions <- function(data, group_var,
                              bar_text_size = 3, x_angle = 30, x_size = 9,
                              return_list = FALSE,
                              titles = c("Mining regulator", "MSR institution", "Env. custodian")) {
  max_value     <- 0.83
  group_var_sym <- enquo(group_var)

  visions <- list(
    list(var = "mean_mr2",  title = titles[1], fill = col_mr),
    list(var = "mean_si2",  title = titles[2], fill = col_msr),
    list(var = "mean_ec2",  title = titles[3], fill = col_ec)
  )

  plots <- lapply(seq_along(visions), function(i) {
    v      <- visions[[i]]
    show_y <- i == 1
    ggplot(data, aes(x = !!group_var_sym, y = !!sym(v$var))) +
      geom_col(fill = v$fill, width = 0.65) +
      geom_text(
        aes(label = round(!!sym(v$var), 2)),
        vjust = 1.5, size = bar_text_size, color = "white", fontface = "bold"
      ) +
      scale_y_continuous(expand = expansion(mult = c(0, 0.02))) +
      coord_cartesian(ylim = c(0, max_value)) +
      theme_bar +
      theme(
        axis.title.y = if (show_y) element_text(size = 9)  else element_blank(),
        axis.text.y  = if (show_y) element_text(size = 8)  else element_blank(),
        axis.text.x  = element_text(angle = x_angle, hjust = 1, size = x_size)
      ) +
      labs(y = if (show_y) "Average score" else NULL, title = v$title)
  })

  if (return_list) return(plots)
  wrap_plots(plots, ncol = 3) & theme(plot.margin = unit(c(5, 10, 5, 10), "pt"))
}


# ── Bar data: development status (Figure 3) ===================================

bar_dev_data <- dta_agg %>%
  pivot_longer(c(developed, developing, ldcs, lldcs, sids),
               names_to = "group", values_to = "has") %>%
  filter(has == 1) %>%
  group_by(group) %>%
  summarise(across(c(mean_mr2, mean_si2, mean_ec2), \(x) mean(x, na.rm = TRUE)),
            n = n(), .groups = "drop") %>%
  mutate(group = factor(group,
    levels = c("developed", "developing", "ldcs", "lldcs", "sids"),
    labels = c("Developed", "Developing", "LDCs", "LLDCs", "SIDS")
  ))


# ── Bar data: moratorium / sponsor + SIDS (Figure 4) ==========================

bar_morasponsor_data <- dta_agg %>%
  filter(actor_type_eh2 == "member state" | actor == "african group") %>%
  group_by(morasponsor) %>%
  summarise(across(c(mean_mr2, mean_si2, mean_ec2), \(x) mean(x, na.rm = TRUE)),
            n = n(), .groups = "drop") %>%
  mutate(morasponsor = factor(morasponsor,
    levels = c("sponsor", "moratorium/pp", "both", "neither"),
    labels = c("Sponsor", "Moratorium/PP", "Both", "Neither")
  ))

bar_sids_data <- dta_agg %>%
  filter(!is.na(sids), sids == 1) %>%
  group_by(sponsorstate) %>%
  summarise(across(c(mean_mr2, mean_si2, mean_ec2), \(x) mean(x, na.rm = TRUE)),
            n = n(), .groups = "drop") %>%
  mutate(sponsorstate = factor(sponsorstate,
    levels = c(1, 0), labels = c("SIDS: Sponsor", "SIDS: Not sponsor")
  ))


# ── Bar data: actor types (Figure 5) ==========================================

bar_type_data <- dta_agg %>%
  filter(
    actor_type_eh2 %in% c("member state", "observer ngo", "isa"),
    !actor %in% c("secretariat", "chair of finance committee",
                  "deputy to the secretary general", "legal counsel",
                  "master of ceremony", "president of council",
                  "head of security", "council",
                  "chair legal and technical commission")
  ) %>%
  mutate(actor_type_eh2 = if_else(actor == "african group",
                                   "member state", actor_type_eh2)) %>%
  group_by(actor_type_eh2) %>%
  summarise(across(c(mean_mr2, mean_si2, mean_ec2), \(x) mean(x, na.rm = TRUE)),
            n = n(), .groups = "drop") %>%
  mutate(actor_type_eh2 = factor(actor_type_eh2,
    levels = c("member state", "observer ngo", "isa"),
    labels = c("Member state", "Observer NGO", "ISA SG")
  ))


# ── Bar data: council membership (Figure 6) ====================================

bar_council_data <- dta_agg %>%
  filter(actor_type_eh2 == "member state" | actor == "african group") %>%
  mutate(council_member = if_else(actor == "african group", 1L, council_member)) %>%
  group_by(council_member) %>%
  summarise(across(c(mean_mr2, mean_si2, mean_ec2), \(x) mean(x, na.rm = TRUE)),
            n = n(), .groups = "drop") %>%
  mutate(council_member = factor(council_member,
    levels = c(1, 0), labels = c("Council member", "Not Council member")
  ))


# ── Plotly bar chart helper ====================================================
# Creates a 3-panel subplot (MR / MSR inst. / EC) for one grouping variable.
# data:        data frame with mean_mr2, mean_si2, mean_ec2, and optionally n
# x_col:       column name (string) for the x-axis grouping
# x_tickangle: angle for x-axis tick labels (default -35)
# titles:      panel titles (length-3 character vector)

make_vision_plotly <- function(data, x_col, x_tickangle = -35,
                                titles = c("Mining regulator",
                                           "MSR institution",
                                           "Env. custodian")) {
  x     <- data[[x_col]]
  has_n <- "n" %in% names(data)

  mk <- function(y_col, clr) {
    y    <- round(data[[y_col]], 3)
    htxt <- if (has_n)
      paste0("<b>", x, "</b><br>Score: <b>", y, "</b><br>n = ", data[["n"]])
    else
      paste0("<b>", x, "</b><br>Score: <b>", y, "</b>")
    plot_ly(
      x = x, y = y, type = "bar",
      marker           = list(color = clr, line = list(width = 0)),
      text             = as.character(y),
      textposition     = "inside",
      insidetextanchor = "middle",
      textangle        = -90,
      textfont         = list(color = "white", size = 12, family = "Lora, serif"),
      hoverinfo        = "text",
      hovertext        = htxt,
      showlegend       = FALSE
    )
  }

  p1 <- mk("mean_mr2", col_mr)
  p2 <- mk("mean_si2", col_msr)
  p3 <- mk("mean_ec2", col_ec)

  # Annotation x-midpoints for 3 equal panels at gap = 0.03
  gap <- 0.03
  w   <- (1 - 2 * gap) / 3
  xm  <- c(w / 2, w + gap + w / 2, 2 * (w + gap) + w / 2)

  annots <- lapply(seq_along(titles), function(i)
    list(text      = paste0("<b>", titles[i], "</b>"),
         x         = xm[i], y = 1.02,
         xref      = "paper", yref = "paper",
         xanchor   = "center", yanchor = "bottom",
         showarrow = FALSE,
         font      = list(size = 14, color = "#1a1a2e", family = "Lora, serif")))

  subplot(p1, p2, p3, shareY = TRUE, titleX = TRUE, margin = gap) %>%
    layout(
      showlegend   = FALSE,
      annotations  = annots,
      bargap    = 0.35,
      font      = list(family = "Lora, serif", size = 12, color = "#333333"),
      dragmode  = FALSE,
      yaxis  = list(range = c(0, 0.87), title = "Average score",
                    gridcolor = "#f0f0f0", fixedrange = TRUE,
                    tickfont  = list(size = 12, family = "Lora, serif"),
                    titlefont = list(size = 12, family = "Lora, serif"),
                    zerolinecolor = "#e0e0e0"),
      yaxis2 = list(range = c(0, 0.87), gridcolor = "#f0f0f0",
                    fixedrange = TRUE, showticklabels = FALSE),
      yaxis3 = list(range = c(0, 0.87), gridcolor = "#f0f0f0",
                    fixedrange = TRUE, showticklabels = FALSE),
      xaxis  = list(tickangle = x_tickangle, fixedrange = TRUE,
                    tickfont = list(size = 13, family = "Lora, serif")),
      xaxis2 = list(tickangle = x_tickangle, fixedrange = TRUE,
                    tickfont = list(size = 13, family = "Lora, serif")),
      xaxis3 = list(tickangle = x_tickangle, fixedrange = TRUE,
                    tickfont = list(size = 13, family = "Lora, serif")),
      margin        = list(l = 60, r = 5, t = 40, b = 100),
      plot_bgcolor  = "rgba(0,0,0,0)",
      paper_bgcolor = "rgba(0,0,0,0)"
    ) %>%
    config(displayModeBar = FALSE)
}


# ── Toggle variant: one vision large + two greyed thumbnails =================
# active_vis: "mr" | "si" | "ec"
# source_id:  must match the plotlyOutput() ID so click events are routed correctly
make_vision_toggle <- function(data, x_col, active_vis = "mr",
                                source_id = "A", x_tickangle = -35) {
  others    <- setdiff(c("mr", "si", "ec"), active_vis)
  vis_order <- c(active_vis, others)

  vis_labels <- c(mr = "Mining regulator", si = "MSR institution",
                  ec = "Env. custodian")
  vis_colors <- c(mr = col_mr, si = col_msr, ec = col_ec)

  x     <- data[[x_col]]
  has_n <- "n" %in% names(data)

  mk <- function(vis, is_active) {
    y_col <- paste0("mean_", vis, "2")
    y     <- round(data[[y_col]], 3)
    clr   <- if (is_active) vis_colors[[vis]] else "rgba(185,185,185,0.45)"
    htxt  <- if (is_active) {
      if (has_n)
        paste0("<b>", x, "</b><br>Score: <b>", y, "</b><br>n = ", data[["n"]])
      else
        paste0("<b>", x, "</b><br>Score: <b>", y, "</b>")
    } else {
      paste0("Switch to <b>", vis_labels[[vis]], "</b>")
    }
    plot_ly(
      source = source_id,
      x = x, y = y, type = "bar",
      name             = vis,
      marker           = list(color = clr, line = list(width = 0)),
      text             = if (is_active) as.character(y) else NULL,
      textposition     = "inside",
      insidetextanchor = "middle",
      textangle        = -90,
      textfont         = list(color = "white", size = if (is_active) 10 else 8),
      hoverinfo        = "text",
      hovertext        = htxt,
      showlegend       = FALSE
    )
  }

  plots <- lapply(vis_order, function(v) mk(v, v == active_vis))

  # Widths: active=0.62, thumbnails=0.19 each (sum=1)
  wts <- c(0.62, 0.19, 0.19)
  gap <- 0.015
  sc  <- 1 - 2 * gap
  cum_w  <- cumsum(wts * sc)
  starts <- c(0, cum_w[-3] + (1:2) * gap)
  ends   <- starts + wts * sc
  mids   <- (starts + ends) / 2

  annots <- lapply(seq_len(3), function(i) {
    v <- vis_order[[i]]
    list(
      text      = if (i == 1) paste0("<b>", vis_labels[[v]], "</b>")
                  else vis_labels[[v]],
      x         = mids[[i]], y = 1.02,
      xref      = "paper",  yref = "paper",
      xanchor   = "center", yanchor = "bottom",
      showarrow = FALSE,
      font      = list(size  = if (i == 1) 11L else 9L,
                       color = if (i == 1) "#1a1a2e" else "#aaa")
    )
  })

  subplot(plots[[1]], plots[[2]], plots[[3]],
          shareY = TRUE, titleX = TRUE,
          widths = wts, margin = gap) %>%
    layout(
      showlegend   = FALSE,
      annotations  = annots,
      yaxis  = list(range = c(0, 0.87), title = "Average score",
                    gridcolor = "#f0f0f0", tickfont = list(size = 9),
                    zerolinecolor = "#e0e0e0"),
      yaxis2 = list(range = c(0, 0.87), showticklabels = FALSE,
                    zeroline = FALSE, showgrid = FALSE),
      yaxis3 = list(range = c(0, 0.87), showticklabels = FALSE,
                    zeroline = FALSE, showgrid = FALSE),
      xaxis  = list(tickangle = x_tickangle, tickfont = list(size = 9),
                    fixedrange = TRUE),
      xaxis2 = list(tickangle = -40, tickfont = list(size = 7),
                    fixedrange = TRUE),
      xaxis3 = list(tickangle = -40, tickfont = list(size = 7),
                    fixedrange = TRUE),
      margin        = list(l = 50, r = 5, t = 30, b = 75),
      plot_bgcolor  = "rgba(0,0,0,0)",
      paper_bgcolor = "rgba(0,0,0,0)"
    ) %>%
    config(displayModeBar = FALSE) %>%
    event_register("plotly_click")
}


# ── World map data (Figure 2 -- for Finding 1 map tab) ========================

.map_ok <- tryCatch({
  library(rnaturalearth)
  library(rnaturalearthdata)
  library(sf)

  .world <- ne_countries(scale = "medium", returnclass = "sf") %>%
    mutate(sovereignt = str_to_lower(sovereignt))

  .dta_map <- dta_agg %>%
    mutate(sovereignt = case_when(
      actor == "usa"                    ~ "united states of america",
      actor == "uk"                     ~ "united kingdom",
      actor == "viet nam"               ~ "vietnam",
      actor == "bahamas"                ~ "the bahamas",
      actor == "tanzania"               ~ "united republic of tanzania",
      actor == "republic of korea"      ~ "south korea",
      actor == "cabo verde"             ~ "cape verde",
      actor == "syrian arabic republic" ~ "syria",
      actor == "papua neu guinea"       ~ "papua new guinea",
      actor == "timor-leste"            ~ "east timor",
      actor == "tunesia"                ~ "tunisia",
      actor == "cote divoire"           ~ "ivory coast",
      TRUE                              ~ actor
    )) %>%
    filter(actor_type_eh2 %in% c("member state", "observer state"),
           sovereignt %in% .world$sovereignt) %>%
    select(sovereignt, mean_mr2, mean_si2, mean_ec2)

  .ag <- dta_agg %>% filter(actor == "african group")
  .ag_countries <- c(
    "algeria","angola","benin","botswana","burkina faso","cameroon","chad",
    "comoros","congo","ivory coast","democratic republic of the congo",
    "djibouti","egypt","equatorial guinea","eswatini","gabon","gambia",
    "ghana","guinea","kenya","lesotho","liberia","madagascar","malawi",
    "mali","mauritania","mauritius","morocco","mozambique","namibia",
    "niger","nigeria","rwanda","senegal","seychelles","sierra leone",
    "somalia","south africa","sudan","togo","tunisia","uganda","zambia","zimbabwe"
  )
  .ag_fill <- tibble(
    sovereignt = .ag_countries,
    mean_mr2   = .ag$mean_mr2,
    mean_si2   = .ag$mean_si2,
    mean_ec2   = .ag$mean_ec2
  ) %>% filter(!sovereignt %in% .dta_map$sovereignt)

  world_map_sf <<- .world %>%
    left_join(bind_rows(.dta_map, .ag_fill), by = "sovereignt")

  rm(.world, .dta_map, .ag, .ag_countries, .ag_fill)
  TRUE
}, error = function(e) {
  message("rnaturalearth not available -- map tab will be disabled: ", e$message)
  world_map_sf <<- NULL
  FALSE
})


# ── Map palette config + pre-computed labels (computed once at startup) ========
# All three vision layers are pre-rendered in renderLeaflet; switching visions
# uses showGroup/hideGroup (instant) rather than re-rendering polygons.

map_pal_cfg <- list(
  mr = list(name = "Mining reg.", col = "mean_mr2",
            pal  = c("#FEF0DC","#E8B87A","#CC8A52","#9E5E2E","#5C2D0A")),
  si = list(name = "MSR inst.",  col = "mean_si2",
            pal  = c("#E3F4F7","#9DD2DA","#5BAAB6","#357A89","#144B57")),
  ec = list(name = "Env. cust.", col = "mean_ec2",
            pal  = c("#E8F7EE","#A4D9B5","#6DB589","#3D8A5A","#14502F"))
)

if (!is.null(world_map_sf)) {
  map_color_fns <- lapply(map_pal_cfg, function(cfg)
    colorNumeric(cfg$pal, domain = c(0, 1), na.color = "#eeeeee"))

  .fmt <- function(x) ifelse(is.na(x), "—", sprintf("%.3f", x))

  map_labels <- lapply(seq_len(nrow(world_map_sf)), function(i) {
    r <- world_map_sf[i, ]
    htmltools::HTML(paste0(
      "<div style='font-family:Lora,serif;line-height:1.75;font-size:12px'>",
      "<b>", r$sovereignt, "</b><br>",
      "Mining reg.: <b>", .fmt(r$mean_mr2), "</b><br>",
      "MSR inst.:&nbsp;&nbsp; <b>", .fmt(r$mean_si2), "</b><br>",
      "Env. cust.:&nbsp;&nbsp; <b>", .fmt(r$mean_ec2), "</b>",
      "</div>"
    ))
  })
  rm(.fmt)
} else {
  map_color_fns <- NULL
  map_labels    <- NULL
}
