

source("global.R")

# ── CSS =======================================================================
css <- "
body, html { background: #FFFFFF; }

/* Navbar: integrate with paper aesthetic */
.navbar {
  background-color: #ffffff !important;
  border-bottom: 2px solid #1a1a2e;
  box-shadow: none !important;
  padding: 0.5rem 1.5rem;
}
.navbar-brand {
  color: #1a1a2e !important;
  font-weight: 700;
  font-size: 1.1rem;
  line-height: 1.3;
  padding-top: 0.35rem;
  padding-bottom: 0.35rem;
}
.navbar .nav-link {
  color: #666 !important;
  font-size: 0.95rem;
  letter-spacing: 0.02em;
  padding-left: 1rem;
  padding-right: 1rem;
}
.navbar .nav-link.active,
.navbar .nav-link:hover {
  color: #1a1a2e !important;
  font-weight: 600;
}
.navbar-nav .nav-item + .nav-item { margin-left: 0.25rem; }

.paper {
  max-width: 860px;
  margin: 0 auto;
  padding: 2.5rem 1.5rem 5rem;
}

.paper-header {
  margin-bottom: 2rem;
  padding-bottom: 1.1rem;
  border-bottom: 2px solid #1a1a2e;
}
.paper-header h1 {
  font-size: 1.95rem;
  font-weight: 700;
  line-height: 1.3;
  color: #1a1a2e;
  margin: 0 0 0.3rem;
}
.paper-header .subtitle {
  font-size: 1.05rem;
  color: #666;
  font-style: italic;
  margin: 0;
}

.paper p {
  font-size: 1rem;
  line-height: 1.92;
  color: #222;
  margin: 0 0 0.9rem;
}

/* Network: full-width, breaks out of paper column */
.network-section {
  max-width: 1440px;
  margin: 2rem auto 0;
  padding: 0 1.5rem;
}
.net-canvas-box {
  border: 1px solid #ddd;
  border-radius: 3px;
  padding: 0.4rem 0.4rem 0.6rem;
  background: #fff;
}
.net-legend-bottom {
  display: flex;
  flex-wrap: wrap;
  gap: 0 1.4rem;
  padding: 0.55rem 0.4rem 0.1rem;
  border-top: 1px solid #eee;
  margin-top: 0.3rem;
}
.net-bottom-controls { padding: 0.8rem 0.2rem 0; }
.net-ctrl-header {
  font-size: 0.68rem;
  font-weight: 800;
  letter-spacing: 0.1em;
  text-transform: uppercase;
  color: #aaa;
  margin-bottom: 0.5rem;
}
.net-ctrl-grid {
  display: grid;
  grid-template-columns: 1fr 1fr 1fr;
  gap: 0.5rem 2.5rem;
  align-items: start;
}
.net-ctrl-col { min-width: 0; }
.ctrl-label {
  font-size: 0.68rem;
  font-weight: 800;
  letter-spacing: 0.1em;
  text-transform: uppercase;
  color: #aaa;
  margin-bottom: 0.4rem;
}
.net-vision-lbl { font-size: 0.72rem; font-weight: 700; margin-bottom: 1px; color: #444; }
.net-legend-bottom div { font-size: 0.82rem; color: #444; line-height: 1.6; }

/* Section divider */
.sec-divider { border: none; border-top: 1px solid #ddd; margin: 2.5rem 0; }

/* Finding sections: text wraps around floated placeholder */
.finding { margin-bottom: 0.5rem; }
.finding::after { content: ''; display: table; clear: both; }

.chart-float-right {
  float: right;
  width: 46%;
  margin: 0.4rem 0 1rem 2.2rem;
}
.chart-float-left {
  float: left;
  width: 46%;
  margin: 0.4rem 2.2rem 1rem 0;
}

.finding-label {
  font-size: 0.7rem;
  font-weight: 800;
  letter-spacing: 0.13em;
  text-transform: uppercase;
  color: #bbb;
  margin-bottom: 0.25rem;
}
.finding h3 {
  font-size: 1.15rem;
  font-weight: 700;
  line-height: 1.45;
  color: #1a1a2e;
  margin: 0 0 0.85rem;
}

/* Three visions grid */
.visions-grid {
  display: grid;
  grid-template-columns: 1fr 1fr 1fr;
  gap: 0 2rem;
  margin: 0.5rem 0 1.5rem;
}
.vision-card {
  border-left: 3px solid #ddd;
  padding: 0.5rem 0 0.5rem 0.9rem;
}
.vision-card h4 {
  font-size: 0.78rem;
  font-weight: 700;
  text-transform: uppercase;
  letter-spacing: 0.06em;
  color: #1a1a2e;
  margin: 0 0 0.35rem;
}
.vision-card p {
  font-size: 0.82rem;
  line-height: 1.65;
  color: #555;
  margin: 0;
}

/* Data tab: no internal card scroll — let the page scroll */
.data-tab {
  padding: 2rem 1.5rem 4rem;
}
.data-tab .card,
.data-tab .card-body,
.data-tab .bslib-card {
  overflow: visible !important;
  max-height: none !important;
  height: auto !important;
}
/* Stop bslib tab pane from clipping content */
.tab-content > .tab-pane,
.tab-content > .active {
  overflow: visible !important;
  height: auto !important;
  max-height: none !important;
}
.data-tab .nav-tabs { border-bottom: 2px solid #1a1a2e; margin-bottom: 1.5rem; }
.data-tab .nav-tabs .nav-link {
  color: #666;
  font-size: 0.88rem;
  letter-spacing: 0.04em;
  font-weight: 600;
  text-transform: uppercase;
  border: none;
  border-bottom: 2px solid transparent;
  margin-bottom: -2px;
  padding: 0.55rem 1rem;
}
.data-tab .nav-tabs .nav-link.active {
  color: #1a1a2e;
  background: none;
  border-bottom: 2px solid #1a1a2e;
}
.data-tab .card {
  border: 1px solid #ddd;
  border-radius: 3px;
  box-shadow: none;
}
.data-tab .card-header {
  background: #fff;
  border-bottom: 1px solid #ddd;
  font-size: 0.72rem;
  font-weight: 800;
  letter-spacing: 0.1em;
  text-transform: uppercase;
  color: #aaa;
  padding: 0.65rem 1rem;
}
.data-tab .card-header {
  display: flex !important;
  align-items: center !important;
  justify-content: space-between !important;
}
/* Controls injected by JS into card header */
.dt-hdr-ctrl {
  display: flex;
  align-items: center;
  gap: 0.6rem;
  flex-shrink: 0;
}
.dt-hdr-ctrl .dt-buttons { display: flex; gap: 0.35rem; }
.dt-hdr-ctrl .dt-buttons .btn {
  font-size: 0.72rem;
  padding: 0.18rem 0.55rem;
  border: 1px solid #ccc;
  background: #fff;
  color: #555;
  border-radius: 2px;
  text-transform: none;
  letter-spacing: normal;
  font-weight: normal;
  box-shadow: none;
}
.dt-hdr-ctrl .dataTables_filter {
  display: flex;
  align-items: center;
}
.dt-hdr-ctrl .dataTables_filter label {
  display: flex;
  align-items: center;
  gap: 0.4rem;
  font-size: 0.78rem;
  font-weight: normal;
  text-transform: none;
  letter-spacing: normal;
  color: #888;
  margin: 0;
}
.dt-hdr-ctrl .dataTables_filter input {
  font-size: 0.8rem;
  padding: 0.18rem 0.5rem;
  border: 1px solid #ddd;
  border-radius: 2px;
  color: #333;
  width: 160px;
}
/* Statements table: fixed row height, clipped text */
#gpt_table { table-layout: fixed; width: 100% !important; }
#gpt_table tbody tr { height: 4.5rem; }
#gpt_table tbody td {
  overflow: hidden;
  white-space: normal;
  word-break: break-word;
  vertical-align: top;
  padding-top: 0.6rem !important;
  line-height: 1.55;
}
#gpt_table tbody td:first-child { white-space: nowrap; font-size: 0.75rem; color: #aaa; }
/* Row hover and selection: no dark flash */
.data-tab table.dataTable tbody tr:hover > td,
.data-tab table.dataTable tbody tr:hover {
  background-color: #f7f7f7 !important;
  color: #333 !important;
}
.data-tab table.dataTable tbody tr.selected > td,
.data-tab table.dataTable tbody tr.selected {
  background-color: #f0f0f0 !important;
  color: #333 !important;
  box-shadow: none !important;
}
.data-tab table.dataTable tbody tr.odd { background-color: #fafafa; }
.data-tab table.dataTable tbody tr.even { background-color: #fff; }
/* Statement modal */
.stmt-modal-actor {
  font-size: 0.7rem; font-weight: 800; text-transform: uppercase;
  letter-spacing: 0.1em; color: #aaa; margin-bottom: 0.5rem;
}
.stmt-modal-text {
  font-size: 0.95rem; line-height: 1.85; color: #222; margin-bottom: 0;
}
.stmt-modal-scores {
  display: flex; gap: 2rem;
  padding: 0.75rem 0; margin: 0.9rem 0;
  border-top: 1px solid #eee; border-bottom: 1px solid #eee;
}
.stmt-modal-score-item { display: flex; flex-direction: column; gap: 0.1rem; }
.stmt-modal-score-label {
  font-size: 0.65rem; font-weight: 800; text-transform: uppercase;
  letter-spacing: 0.08em; color: #aaa;
}
.stmt-modal-score-val { font-size: 1rem; font-weight: 600; color: #1a1a2e; }
.stmt-modal-expl-label {
  font-size: 0.65rem; font-weight: 800; text-transform: uppercase;
  letter-spacing: 0.1em; color: #aaa; margin-bottom: 0.45rem;
}
.stmt-modal-expl { font-size: 0.9rem; line-height: 1.8; color: #444; }
/* Actor selectize filter in statements header */
.data-tab .card-header .selectize-input {
  font-size: 0.82rem !important;
  text-transform: none !important;
  letter-spacing: normal !important;
  font-weight: normal !important;
  color: #333 !important;
}
.data-tab table.dataTable thead th {
  font-size: 0.78rem;
  font-weight: 700;
  letter-spacing: 0.04em;
  color: #333;
  border-bottom: 1px solid #ccc !important;
}
.data-tab table.dataTable tbody td {
  font-size: 0.85rem;
  color: #333;
  border-top: 1px solid #f0f0f0;
  vertical-align: middle;
}
/* Pagination: override flatly teal — Bootstrap 5 uses .page-link / .page-item */
.data-tab .dataTables_wrapper .dataTables_info {
  font-size: 0.78rem;
  color: #aaa;
  padding-top: 0.8rem;
}
.data-tab .dataTables_wrapper .dataTables_paginate {
  padding-top: 0.6rem;
  padding-bottom: 0.5rem;
}
.data-tab .pagination .page-link {
  font-size: 0.78rem !important;
  color: #666 !important;
  background-color: #fff !important;
  border-color: #e0e0e0 !important;
  box-shadow: none !important;
}
.data-tab .pagination .page-link:hover,
.data-tab .pagination .page-link:focus {
  color: #333 !important;
  background-color: #f5f5f5 !important;
  border-color: #ccc !important;
  box-shadow: none !important;
}
.data-tab .pagination .page-item.active .page-link {
  background-color: #1a1a2e !important;
  border-color: #1a1a2e !important;
  color: #fff !important;
}
.data-tab .pagination .page-item.disabled .page-link {
  background-color: #fff !important;
  border-color: #eee !important;
  color: #ccc !important;
}
.data-tab .dataTables_wrapper { padding-bottom: 1.5rem; }
"


# ── UI ========================================================================
ui <- page_navbar(
  title = "Lorem Ipsum Dolor Sit Amet",
  theme = bs_theme(
    bootswatch   = "flatly",
    primary      = "#2C3E6B",
    base_font    = font_google("Lora"),
    heading_font = font_google("Lora")
  ),
  fillable = FALSE,
  tags$head(tags$style(HTML(css))),


  # ── Tab 1: Findings =========================================================
  nav_panel("Findings", icon = bs_icon("file-text"),

    # Intro text in paper column
    div(class = "paper",
      div(class = "paper-header",
        tags$h1("Lorem Ipsum Dolor Sit Amet Consectetur"),
        p(class = "subtitle", "Lorem Ipsum, Dolor Sit | Amet Elit Journal, 2024")
      ),
      tags$p(
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor
        incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud
        exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure
        dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.
        Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt
        mollit anim id est laborum."
      ),
      tags$p(
        "Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque
        laudantium, totam rem aperiam eaque ipsa quae ab illo inventore veritatis et quasi
        architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas
        sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione
        voluptatem sequi nesciunt."
      )
    ),

    # Three visions explainer in paper column
    div(class = "paper",
      tags$hr(class = "sec-divider"),
      tags$p(
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor
        incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud
        exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat."
      ),
      div(class = "visions-grid",
        div(class = "vision-card",
          tags$h4("Mining Regulator"),
          tags$p(
            "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor
            incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam quis nostrud."
          )
        ),
        div(class = "vision-card",
          tags$h4("MSR Institution"),
          tags$p(
            "Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium
            doloremque laudantium, totam rem aperiam eaque ipsa quae ab illo inventore."
          )
        ),
        div(class = "vision-card",
          tags$h4("Environmental Custodian"),
          tags$p(
            "At vero eos et accusamus et iusto odio dignissimos ducimus qui blanditiis
            praesentium voluptatum deleniti atque corrupti quos dolores et quas molestias."
          )
        )
      )
    ),

    # 3D vision-space scatter
    div(class = "network-section",
      div(class = "net-ctrl-header", style = "margin-bottom: 0.6rem;",
        "Actor positions in vision space"
      ),
      div(class = "net-canvas-box",
        plotlyOutput("scatter3d_plot", height = "580px")
      )
    ),

    # Full-width network (breaks out of paper column)
    div(class = "network-section",
      div(class = "net-canvas-box",
        visNetworkOutput("network_plot", height = "640px"),
        div(class = "net-legend-bottom",
          div(class = "ctrl-label", style = "width:100%; margin-bottom:0.3rem;", "Clusters"),
          tags$div(HTML('<span style="color:#FFFFFF;text-shadow:-1px -1px 0 #555,1px -1px 0 #555,-1px 1px 0 #555,1px 1px 0 #555; font-size:1.1rem;">&#9670;</span> Vision node')),
          tags$div(HTML('<span style="color:#3C3C3C; font-size:1.1rem;">&#9679;</span> Cluster 1')),
          tags$div(HTML('<span style="color:#ABABAB; font-size:1.1rem;">&#9650;</span> Cluster 2')),
          tags$div(HTML('<span style="color:#686868; font-size:1.1rem;">&#9670;</span> Cluster 3')),
          tags$div(HTML('<span style="color:#C8C8C8;text-shadow:0 0 2px #999; font-size:1.1rem;">&#9632;</span> Cluster 4')),
          tags$div(HTML('<span style="color:#242424; font-size:1.1rem;">&#9660;</span> Cluster 5'))
        )
      ),
      div(class = "net-bottom-controls",
        div(class = "net-ctrl-header", "Min. score"),
        div(class = "net-ctrl-grid",
          div(class = "net-ctrl-col",
            div(class = "net-vision-lbl", "Env. Cust."),
            sliderInput("net_ec_min", NULL,
              min = 0, max = 1, value = 0, step = 0.05, ticks = FALSE)
          ),
          div(class = "net-ctrl-col",
            div(class = "net-vision-lbl", "MSR Inst."),
            sliderInput("net_si_min", NULL,
              min = 0, max = 1, value = 0, step = 0.05, ticks = FALSE)
          ),
          div(class = "net-ctrl-col",
            div(class = "net-vision-lbl", "Mining Reg."),
            sliderInput("net_mr_min", NULL,
              min = 0, max = 1, value = 0, step = 0.05, ticks = FALSE)
          )
        )
      )
    ),

    # Findings in paper column
    div(class = "paper",
      tags$hr(class = "sec-divider"),

      # Finding 1: placeholder floated right, text wraps left
      div(class = "finding",
        div(class = "chart-float-right",
          div(style = paste(
            "height:295px; background:#f4f4f4; display:flex;",
            "align-items:center; justify-content:center;",
            "color:#aaa; font-size:0.85rem;",
            "border:1px solid #e0e0e0; border-radius:4px;"
          ), "[bar plot here]")
        ),
        div(class = "finding-label", "Finding 1"),
        tags$h3("Lorem ipsum dolor sit amet, consectetur adipiscing elit"),
        tags$p(
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor
          incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud
          exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute
          irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla."
        ),
        tags$p(
          "Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt
          mollit anim id est laborum. Sed ut perspiciatis unde omnis iste natus error sit
          voluptatem accusantium doloremque laudantium, totam rem aperiam eaque ipsa quae ab
          illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo."
        )
      ),

      tags$hr(class = "sec-divider"),

      # Finding 2: placeholder floated left, text wraps right
      div(class = "finding",
        div(class = "chart-float-left",
          div(style = paste(
            "height:295px; background:#f4f4f4; display:flex;",
            "align-items:center; justify-content:center;",
            "color:#aaa; font-size:0.85rem;",
            "border:1px solid #e0e0e0; border-radius:4px;"
          ), "[bar plot here]")
        ),
        div(class = "finding-label", "Finding 2"),
        tags$h3("Sed do eiusmod tempor incididunt ut labore et dolore magna"),
        tags$p(
          "At vero eos et accusamus et iusto odio dignissimos ducimus qui blanditiis
          praesentium voluptatum deleniti atque corrupti quos dolores et quas molestias
          excepturi sint occaecati cupiditate non provident, similique sunt in culpa qui
          officia deserunt mollitia animi, id est laborum et dolorum fuga."
        ),
        tags$p(
          "Nam libero tempore, cum soluta nobis est eligendi optio cumque nihil impedit quo
          minus id quod maxime placeat facere possimus, omnis voluptas assumenda est, omnis
          dolor repellendus. Temporibus autem quibusdam et aut officiis debitis rerum
          necessitatibus saepe eveniet ut et voluptates repudiandae sint et molestiae."
        )
      )
    )
  ),


  # ── Tab 2: Data =============================================================
  nav_panel("Data", icon = bs_icon("database"),
    div(class = "data-tab",
      navset_tab(

        nav_panel("Actor Scores", icon = bs_icon("table"),
          br(),
          card(fill = FALSE,
            card_header(
              span("Actor-level mean vision scores"),
              div(id = "actor-hdr-ctrl", class = "dt-hdr-ctrl")
            ),
            DTOutput("actor_table")
          )
        ),

        nav_panel("Statements", icon = bs_icon("chat-left-text"),
          br(),
          card(fill = FALSE,
            card_header(
              span("Statements — click any row to view the full text and model explanation"),
              div(class = "dt-hdr-ctrl",
                div(id = "gpt-hdr-ctrl"),
                div(style = "width:200px;",
                  selectizeInput("gpt_actor", NULL,
                    choices  = c("All actors" = "All", sort(unique(gpt_results$actor))),
                    selected = "All", width = "100%"
                  )
                )
              )
            ),
            DTOutput("gpt_table")
          )
        )
      )
    )
  )
)


# ── Server ====================================================================
server <- function(input, output, session) {

  # 3D vision-space scatter
  output$scatter3d_plot <- renderPlotly({

    df <- dta_agg %>%
      filter(!is.na(mean_mr2), !is.na(mean_si2), !is.na(mean_ec2)) %>%
      mutate(
        label = str_to_title(actor),
        type_clean = case_when(
          actor_type_eh2 == "member state" | actor == "african group" ~ "Member State",
          actor_type_eh2 == "observer ngo"                            ~ "Observer NGO",
          actor_type_eh2 == "isa"                                     ~ "ISA",
          TRUE                                                         ~ "Other"
        ),
        hover = paste0(
          "<b>", str_to_title(actor), "</b><br>",
          "Mining Reg.: <b>", round(mean_mr2, 3), "</b><br>",
          "MSR Inst.:   <b>", round(mean_si2, 3), "</b><br>",
          "Env. Cust.:  <b>", round(mean_ec2, 3), "</b>"
        )
      )

    type_colours <- c(
      "Member State" = "#2C3E6B",
      "Observer NGO" = "#888888",
      "ISA"          = "#B63F7B",
      "Other"        = "#aaaaaa"
    )

    plot_ly(
      data   = df,
      x      = ~mean_mr2,
      y      = ~mean_si2,
      z      = ~mean_ec2,
      color  = ~type_clean,
      colors = type_colours,
      type   = "scatter3d",
      mode   = "markers",
      text   = ~hover,
      hoverinfo = "text",
      marker = list(size = 5, opacity = 0.82, line = list(width = 0))
    ) %>%
      layout(
        scene = list(
          xaxis = list(
            title = "Mining Reg.", range = c(0, 1),
            tickfont = list(size = 10), titlefont = list(size = 11),
            gridcolor = "#e8e8e8", zerolinecolor = "#cccccc"
          ),
          yaxis = list(
            title = "MSR Inst.", range = c(0, 1),
            tickfont = list(size = 10), titlefont = list(size = 11),
            gridcolor = "#e8e8e8", zerolinecolor = "#cccccc"
          ),
          zaxis = list(
            title = "Env. Cust.", range = c(0, 1),
            tickfont = list(size = 10), titlefont = list(size = 11),
            gridcolor = "#e8e8e8", zerolinecolor = "#cccccc"
          ),
          bgcolor = "#ffffff",
          camera  = list(eye = list(x = 1.5, y = 1.5, z = 0.8))
        ),
        legend = list(
          x = 0.01, y = 0.99,
          font = list(size = 11, family = "Lora, serif"),
          bgcolor = "rgba(255,255,255,0.85)",
          bordercolor = "#dddddd", borderwidth = 1
        ),
        margin       = list(l = 0, r = 0, t = 0, b = 0),
        paper_bgcolor = "#ffffff",
        font = list(family = "Lora, serif", color = "#333333")
      ) %>%
      config(displayModeBar = FALSE)
  })

  # Network: render once with all nodes; proxy updates hidden property on slider change
  # (avoids zoom reset that a full re-render would cause)
  output$network_plot <- renderVisNetwork({
    visNetwork(net_nodes, net_edges) %>%
      visNodes(
        borderWidth = 1.5,
        color = list(
          border    = "#333333",
          highlight = list(background = "#444444", border = "#111111"),
          hover     = list(background = "#555555", border = "#111111")
        )
      ) %>%
      visEdges(
        smooth = FALSE,
        color  = list(color = "rgba(0,0,0,0.07)", highlight = "rgba(0,0,0,0.3)")
      ) %>%
      visOptions(
        highlightNearest = list(enabled = TRUE, degree = 1, hover = TRUE),
        nodesIdSelection = FALSE
      ) %>%
      visPhysics(enabled = FALSE) %>%
      visInteraction(
        navigationButtons = FALSE,
        zoomView          = TRUE,
        dragView          = TRUE,
        tooltipDelay      = 100
      )
  })

  observe({
    qualifying <- dta_agg %>%
      filter(
        is.na(mean_mr2) | mean_mr2 >= input$net_mr_min,
        is.na(mean_si2) | mean_si2 >= input$net_si_min,
        is.na(mean_ec2) | mean_ec2 >= input$net_ec_min
      ) %>%
      transmute(id = str_replace_all(actor, " ", "_")) %>%
      pull(id)

    nodes_update <- net_nodes %>%
      transmute(id, hidden = !(type == "vision" | id %in% qualifying))

    visNetworkProxy("network_plot") %>%
      visUpdateNodes(nodes = nodes_update)
  })

  # Actor table
  output$actor_table <- renderDT({
    dta_agg %>%
      select(
        Actor          = actor,
        Type           = actor_type_eh2,
        Statements     = n_statements,
        `Mining Reg.`  = mean_mr2,
        `MSR Inst.`    = mean_si2,
        `Env. Cust.`   = mean_ec2,
        `Mora/Sponsor` = morasponsor,
        Council        = council_member,
        Region         = regional_group
      ) %>%
      mutate(
        Actor = str_to_title(Actor),
        across(c(`Mining Reg.`, `MSR Inst.`, `Env. Cust.`), ~ round(.x, 3))
      ) %>%
      datatable(
        rownames = FALSE, extensions = "Buttons",
        options = list(
          pageLength = 20, dom = "Bftip",
          buttons = list(
            list(extend = "csv",   text = "Download CSV",   filename = "actor_scores"),
            list(extend = "excel", text = "Download Excel", filename = "actor_scores")
          ),
          autoWidth  = FALSE,
          columnDefs = list(
            list(className = "dt-left", targets = "_all"),
            list(
              targets = c(3, 4, 5),
              createdCell = JS("function(td, cellData, rowData, row, col) {
                var v = parseFloat(cellData);
                if (!isNaN(v)) {
                  var pct = (Math.max(0, Math.min(1, v)) * 100).toFixed(1);
                  td.style.background = 'linear-gradient(90deg, #d8d8d8 ' + pct + '%, transparent ' + pct + '%)';
                  td.style.backgroundSize = '100% 65%';
                  td.style.backgroundRepeat = 'no-repeat';
                  td.style.backgroundPosition = '0% 50%';
                }
              }")
            )
          ),
          initComplete = JS("function(settings, json) {
            var $ctrl = $('#actor-hdr-ctrl');
            var $wrap = $(this.api().table().container());
            $ctrl.prepend($wrap.find('.dataTables_filter').detach());
            $ctrl.prepend($wrap.find('.dt-buttons').detach());
          }")
        )
      )
  })

  # Statement browser
  gpt_view <- reactive({
    df <- gpt_results
    if (input$gpt_actor != "All") df <- df %>% filter(actor == input$gpt_actor)
    df %>%
      select(
        ID            = id_statement,
        Actor         = actor,
        Statement     = statement,
        `Mining Reg.` = mining_regulator,
        `MSR Inst.`   = science_institution,
        `Env. Cust.`  = environmental_custodian
      ) %>%
      mutate(across(c(`Mining Reg.`, `MSR Inst.`, `Env. Cust.`), ~ round(.x, 3)))
  })

  output$gpt_table <- renderDT({
    datatable(gpt_view(),
      selection = "single", rownames = FALSE,
      options = list(
        pageLength = 10, dom = "ftip", autoWidth = FALSE,
        columnDefs = list(
          list(className = "dt-left",  targets = "_all"),
          list(width = "105px",        targets = 0),   # ID
          list(width = "120px",        targets = 1),   # Actor
          list(width = "auto",         targets = 2),   # Statement
          list(width = "85px",         targets = c(3, 4, 5)),
          list(
            targets = 2,
            render = JS("function(data, type, row) {
              if (type !== 'display' || !data) return data;
              return data.length > 280 ? data.substring(0, 280) + '…' : data;
            }")
          )
        ),
        initComplete = JS("function(settings, json) {
          var $ctrl = $('#gpt-hdr-ctrl');
          var $wrap = $(this.api().table().container());
          $ctrl.append($wrap.find('.dataTables_filter').detach());
        }")
      )
    )
  })

  observeEvent(input$gpt_table_rows_selected, {
    req(length(input$gpt_table_rows_selected) > 0)
    sel    <- input$gpt_table_rows_selected
    row_id <- gpt_view()$ID[sel]
    row    <- gpt_results %>% filter(id_statement == row_id)

    showModal(modalDialog(
      size = "l", easyClose = TRUE,
      footer = modalButton("Close"),
      title  = div(class = "stmt-modal-actor", str_to_title(row$actor)),
      tagList(
        div(class = "stmt-modal-text", row$statement),
        div(class = "stmt-modal-scores",
          div(class = "stmt-modal-score-item",
            div(class = "stmt-modal-score-label", "Mining Reg."),
            div(class = "stmt-modal-score-val",   round(row$mining_regulator, 3))
          ),
          div(class = "stmt-modal-score-item",
            div(class = "stmt-modal-score-label", "MSR Inst."),
            div(class = "stmt-modal-score-val",   round(row$science_institution, 3))
          ),
          div(class = "stmt-modal-score-item",
            div(class = "stmt-modal-score-label", "Env. Cust."),
            div(class = "stmt-modal-score-val",   round(row$environmental_custodian, 3))
          )
        ),
        div(class = "stmt-modal-expl-label", "Model explanation"),
        div(class = "stmt-modal-expl", row$explanation)
      )
    ))
  })
}

shinyApp(ui, server)
