library(tidyverse)
library(readxl)
library(DT)
library(plotly)
library(visNetwork)
library(bslib)
library(bsicons)

# Paths
data_dir  <- file.path("data", "working_data")
gephi_dir <- file.path("data", "gephi")
gpt_dir   <- file.path("data", "gpt_results")

# Actor aggregate data
dta_agg <- read_csv(
  file.path(data_dir, "dta_agg_SUBMITTED.csv"),
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
    actor == "qatar"                            ~ "quatar",
    actor == "russian federation"               ~ "russia",
    actor == "united republic of tanzania"      ~ "tanzania",
    actor == "united kingdom"                   ~ "uk",
    actor == "united states"                    ~ "usa",
    TRUE                                        ~ actor
  ))

dta_agg <- dta_agg %>% left_join(un_countries, by = "actor")

# Network data
raw_nodes <- read_csv(file.path(gephi_dir, "nodes.csv"), show_col_types = FALSE)
raw_edges <- read_csv(file.path(gephi_dir, "edges.csv"), show_col_types = FALSE)

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
nudge_apart <- function(nodes, min_dist = 25, jitter = 35, iters = 120) {
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
    # Shape by actor type; vision nodes stay as diamond
    shape = case_when(
      type == "vision"                                        ~ "diamond",
      actor_type_eh2 == "member state" | id == "african_group" ~ "dot",
      actor_type_eh2 == "observer ngo"                        ~ "square",
      actor_type_eh2 == "isa"                                 ~ "diamond",
      TRUE                                                    ~ "triangle"
    ),
    # Muted cluster colours (same palette as 3D scatter)
    color = case_when(
      type == "vision" ~ "#FFFFFF",
      cluster5 == 1    ~ "#6DB589",
      cluster5 == 2    ~ "#BC7798",
      cluster5 == 3    ~ "#5BAAB6",
      cluster5 == 4    ~ "#CC8A52",
      cluster5 == 5    ~ "#8A7ABF",
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

net_edges <- raw_edges %>%
  filter(target %in% c("mr", "si", "ec"), weight >= 0.05) %>%
  rename(from = source, to = target) %>%
  mutate(
    width = weight * 1.8,
    color = "rgba(0,0,0,0.07)"
  )

# GPT model output
gpt_results <- read_csv(
  file.path(gpt_dir, "results_parsed_20251128_212532.csv"),
  show_col_types = FALSE
) %>%
  filter(actor %in% dta_agg$actor) %>%
  select(id_statement, actor, statement, mining_regulator, science_institution,
         environmental_custodian, explanation) %>%
  mutate(actor = str_to_title(actor))

# Scale and vision definitions
understandings <- read_excel(file.path(gpt_dir, "understandings.xlsx"))
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
