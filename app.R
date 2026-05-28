

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
  padding: 2.5rem 1.5rem 1.5rem;
}
.paper-last {
  padding-bottom: 5rem;
}

.paper-header {
  margin-bottom: 2rem;
  padding-bottom: 1.1rem;
  border-bottom: 2px solid #1a1a2e;
  text-align: left;
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
.paper h2 {
  font-size: 1.3rem;
  font-weight: 700;
  color: #1a1a2e;
  margin: 1.6rem 0 0.5rem;
  line-height: 1.35;
}
.paper h3 {
  font-size: 1.05rem;
  font-weight: 700;
  color: #1a1a2e;
  margin: 1.4rem 0 0.4rem;
  line-height: 1.4;
}

/* Network: capped-width outer container, responsive flex */
.network-section {
  max-width: 1440px;
  margin: 2rem auto 0;
  display: flex;
  align-items: stretch;
  border: 1px solid #ddd;
  border-radius: 3px;
  background: #fff;
  overflow: hidden;
}
.net-canvas-box {
  flex: 1;
  min-width: 0;
  display: flex;
  align-items: stretch;
  border-right: 1px solid #ddd;
}
@media (max-width: 1199px) {
  .network-section { flex-direction: column; }
  .net-canvas-box { border-right: none; border-bottom: 1px solid #ddd; }
}
.net-plot-area {
  flex: 1;
  min-width: 0;
  position: relative;
  padding: 0.4rem;
}

/* ── Legend: CSS-swatch overhaul ─────────────────────────────────────── */
.net-legend-side {
  width: 158px;
  flex-shrink: 0;
  border-left: 1px solid #eee;
  padding: 0.85rem 0.75rem;
  display: flex;
  flex-direction: column;
  gap: 0.02rem;
}
.legend-section-label {
  font-size: 0.6rem;
  font-weight: 800;
  letter-spacing: 0.11em;
  text-transform: uppercase;
  color: #c8c8c8;
  margin: 0.1rem 0 0.3rem;
}
.legend-item {
  display: flex;
  align-items: center;
  gap: 0.45rem;
  font-size: 0.8rem;
  color: #444;
  line-height: 1.65;
  cursor: pointer;
  transition: opacity 0.15s;
  user-select: none;
  padding: 0.04rem 0.15rem;
  border-radius: 2px;
}
.legend-item:hover { opacity: 0.55; }
.legend-item.inactive { opacity: 0.2; }
.legend-item.inactive:hover { opacity: 0.4; }
.legend-static {
  display: flex;
  align-items: center;
  gap: 0.45rem;
  font-size: 0.8rem;
  color: #bbb;
  line-height: 1.65;
  padding: 0.04rem 0.15rem;
  font-style: italic;
}
.lgd-sep { border: none; border-top: 1px solid #f0f0f0; margin: 0.55rem 0 0.45rem; }
.lgd-sw { display: inline-block; width: 9px; height: 9px; flex-shrink: 0; margin-top: 0.06rem; }
.lgd-circle { border-radius: 50%; }
.lgd-square { border-radius: 1px; }
.lgd-diamond { border-radius: 1px; transform: rotate(45deg); width: 8px; height: 8px; }
.lgd-tri {
  display: inline-block;
  width: 0; height: 0;
  background: transparent !important;
  border-left: 5px solid transparent;
  border-right: 5px solid transparent;
  flex-shrink: 0;
  margin-top: 0.14rem;
}
.reset-filter-btn {
  margin-top: auto;
  padding: 0.55rem 0 0;
  border-top: 1px solid #f0f0f0;
  border-left: none; border-right: none; border-bottom: none;
  font-size: 0.67rem;
  color: #ccc;
  background: none;
  cursor: pointer;
  text-align: left;
  font-family: inherit;
  width: 100%;
  line-height: 1.4;
  display: flex;
  align-items: center;
  gap: 0.3rem;
}
.reset-filter-btn:hover { color: #555; }
.view-btn-group {
  position: absolute;
  top: 0.6rem;
  right: 0.6rem;
  z-index: 100;
  display: flex;
  gap: 0.35rem;
}
.view-toggle-btn {
  font-size: 0.72rem;
  padding: 0.22rem 0.65rem;
  background: #fff;
  border: 1px solid #ccc;
  border-radius: 2px;
  cursor: pointer;
  color: #555;
  font-family: inherit;
}
.view-toggle-btn:hover { background: #f5f5f5; }
.reset-view-btn,
.fullscreen-btn {
  padding: 0.2rem 0.38rem;
  background: #fff;
  border: 1px solid #ccc;
  border-radius: 2px;
  cursor: pointer;
  color: #555;
  display: flex;
  align-items: center;
  justify-content: center;
  line-height: 1;
}
.reset-view-btn:hover,
.fullscreen-btn:hover { background: #f5f5f5; }
/* Fullscreen mode: let the network section fill the screen */
.network-section:-webkit-full-screen { max-width: 100%; border-radius: 0; }
.network-section:-moz-full-screen    { max-width: 100%; border-radius: 0; }
.network-section:fullscreen          { max-width: 100%; border-radius: 0; }
.ctrl-label {
  font-size: 0.68rem;
  font-weight: 800;
  letter-spacing: 0.1em;
  text-transform: uppercase;
  color: #aaa;
  margin-bottom: 0.4rem;
}

/* Section divider */
.sec-divider { border: none; border-top: 1px solid #bbb; margin: 1.6rem 0; }

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

/* ── Actor Comparison Module ─────────────────────────────────────────────── */
.comparison-section {
  display: flex;
  flex-shrink: 0;
  background: #fff;
}
/* Wide: right column, controls stacked above chart */
@media (min-width: 1200px) {
  .comparison-section { width: 340px; flex-direction: column; }
  .comp-controls { border-bottom: 1px solid #eee; flex-shrink: 0; }
  .comp-chart-area { flex: 1; min-height: 0; }
}
/* Narrow: below, controls on left, chart on right */
@media (max-width: 1199px) {
  .comparison-section { flex-direction: row; width: 100%; }
  .comp-controls { width: 210px; flex-shrink: 0; border-right: 1px solid #eee; }
  .comp-chart-area { flex: 1; min-width: 0; }
}
.comp-controls {
  display: flex;
  flex-direction: column;
  gap: 0.6rem;
  padding: 0.85rem 0.85rem;
}
.comp-chart-area {
  display: flex;
  align-items: stretch;
}
.comp-section-label {
  font-size: 0.65rem;
  font-weight: 800;
  letter-spacing: 0.1em;
  text-transform: uppercase;
  color: #aaa;
}
.comp-hint {
  font-size: 0.73rem;
  color: #c5c5c5;
  font-style: italic;
  line-height: 1.4;
  margin-top: -0.2rem;
}
.comp-slot { display: flex; align-items: center; gap: 0.5rem; }
.comp-slot .form-group { margin: 0; flex: 1; }
.comp-slot .selectize-input {
  font-size: 0.8rem !important;
  padding: 0.18rem 0.45rem !important;
  min-height: 0 !important;
  border-color: #e0e0e0 !important;
  border-radius: 2px !important;
  box-shadow: none !important;
  line-height: 1.4 !important;
}
.comp-slot .selectize-dropdown { font-size: 0.8rem !important; border-radius: 2px !important; }
/* Score readout block shown under each dropdown when actor is selected */
.comp-scores {
  padding: 0.3rem 0.25rem 0.1rem 0.6rem;
  margin-top: -0.25rem;
  border-left: 2px solid;
  display: flex;
  flex-direction: column;
  gap: 0.18rem;
}
.comp-score-row {
  display: flex;
  align-items: center;
  gap: 0.45rem;
  font-size: 0.7rem;
}
.comp-score-lbl {
  width: 1.45rem;
  font-size: 0.64rem;
  font-weight: 800;
  letter-spacing: 0.06em;
  text-transform: uppercase;
  color: #ccc;
  flex-shrink: 0;
}
.comp-score-bar {
  flex: 1;
  height: 3px;
  background: #f0f0f0;
  border-radius: 1px;
  overflow: hidden;
}
.comp-score-fill { height: 100%; border-radius: 1px; }
.comp-score-val {
  min-width: 2.2rem;
  text-align: right;
  color: #666;
  font-variant-numeric: tabular-nums;
}
.comparison-slot-badge {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  font-size: 0.6rem;
  font-weight: 800;
  letter-spacing: 0.08em;
  width: 1.35rem;
  height: 1.35rem;
  border-radius: 2px;
  flex-shrink: 0;
}
.slot-a-badge { background: rgba(44,62,107,0.10); color: #2C3E6B; }
.slot-b-badge { background: rgba(182,63,123,0.10); color: #B63F7B; }

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
        tags$h1("Negotiating futures: Three visions for the International Seabed Authority"),
        p(class = "subtitle", "Paper by Emil W. Hildebrand and Alice B. M. Vadrot | ERC TwinPolitics project, 2026")
      ),
      tags$p(HTML(
        'You are looking at the interactive web version of our paper <strong>Negotiating futures: Three visions for the International Seabed Authority</strong>.
        The full published version of it can be <a href="https://doi.org" target="_blank">found here</a>. Use the visualisations to explore our main findings, and visit
        <a href="#" onclick="document.querySelector(\'[data-bs-toggle=tab][data-value=Data]\').click(); return false;">the data tab</a>
        to browse the underlying data. For questions or feedback, please contact Emil W. Hildebrand.'
      )),
      
      tags$hr(class = "sec-divider"),
      
      tags$h2("Introduction"),
      tags$p(
        "The International Seabed Authority (ISA), tasked with governing the international seabed (‘the Area’)
        and its mineral resources ‘for the benefit of humankind as a whole’, has historically operated as a mining
        regulator – responsible for negotiating the ‘Mining Code’ and to facilitate the commercial exploitation
        of the deep seabed. But the prospect of deep-sea mining is facing multiple challenges:
        40 countries, more than 900 scientists, and major global firms have called for a moratorium
        or precautionary pause on deep-sea mining amidst mounting concerns over environmental impacts,
        knowledge gaps, and economic uncertainty. Facing external pressures, new leadership, and a delayed
        periodic review, the ISA as an institution stands at a critical juncture – a moment of institutional
        flux where negotiators are debating not just the Mining Code, but the very purpose and future of the institution itself."
      ),
      tags$p(
        "During these negotiations, delegates articulate, debate, and negotiate different understandings of the ISA’s
        role, purpose, and future priorities. We treat these ideas as they surface in the negotiations as the
        ‘discursive seeds’ of potential futures – explicit or implicit visions for the ISA’s future that
        may reshape the institution from within."
      ),
      tags$p(
        "To map these discursive seeds, we explore alternative paths for the ISA by constructing three distinct visions
        based on selected legal responsibilities of the ISA under UNCLOS: the ISA as a ", HTML("<strong>Mining Regulator</strong>"), " a ",
        HTML("<strong>Marine Scientific Research (MSR) Institution</strong>"), " and an ", HTML("<strong>Environmental Custodian</strong>."), " We then systematically analyse
        how different actors invoke these three visions during ISA negotiations. Using an LLM-based content analysis
        of a comprehensive dataset from the ISA’s 30th Session (2025) – collected via Collaborative Event Ethnography
        across more than 150 hours of negotiations – we map when and how strongly actors invoke each of the three visions."
      ),
      
      tags$hr(class = "sec-divider"),
      
      tags$h2("Visions"),
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
      ),
      
      tags$hr(class = "sec-divider"),
      
      tags$h2("Findings"),
      tags$p(
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor
        incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud
        exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat."
      )
    ),

    # Combined network / 3D view
    div(class = "network-section",
      div(class = "net-canvas-box",

        # Plot area (flex column: plots on top, filter strip on bottom)
        div(class = "net-plot-area",
          div(class = "view-btn-group",
            tags$button(id = "reset-view-btn",  class = "reset-view-btn",  title = "Reset view",       bs_icon("aspect-ratio")),
            tags$button(id = "fullscreen-btn",  class = "fullscreen-btn",  title = "Fullscreen",       bs_icon("arrows-fullscreen")),
            tags$button(id = "view-toggle-btn", class = "view-toggle-btn", title = "Switch view", "Switch to 3D")
          ),
          div(id = "net-plot-wrap",
            visNetworkOutput("network_plot", height = "600px")
          ),
          div(id = "sc3-plot-wrap", style = "display:none;",
            plotlyOutput("scatter3d_plot", height = "600px")
          ),
        ),

        # Legend: right-hand side, CSS-swatch design
        div(class = "net-legend-side",

          # Cluster section
          div(class = "legend-section-label", "Cluster"),
          div(class = "legend-static",
            tags$span(class = "lgd-sw lgd-diamond", style = "background:#cccccc;"),
            tags$span("Vision pole")
          ),
          div(class = "legend-item", id = "legend-cl-1",
            onclick = "toggleLegend('cluster','1',this)",
            tags$span(class = "lgd-sw lgd-circle", style = "background:#6DB589;"),
            tags$span("Env. Custodian")
          ),
          div(class = "legend-item", id = "legend-cl-3",
            onclick = "toggleLegend('cluster','3',this)",
            tags$span(class = "lgd-sw lgd-circle", style = "background:#5BAAB6;"),
            tags$span("EC + MSR")
          ),
          div(class = "legend-item", id = "legend-cl-5",
            onclick = "toggleLegend('cluster','5',this)",
            tags$span(class = "lgd-sw lgd-circle", style = "background:#8A7ABF;"),
            tags$span("Mixed")
          ),
          div(class = "legend-item", id = "legend-cl-2",
            onclick = "toggleLegend('cluster','2',this)",
            tags$span(class = "lgd-sw lgd-circle", style = "background:#BC7798;"),
            tags$span("MR + Env. Cust.")
          ),
          div(class = "legend-item", id = "legend-cl-4",
            onclick = "toggleLegend('cluster','4',this)",
            tags$span(class = "lgd-sw lgd-circle", style = "background:#CC8A52;"),
            tags$span("Mining Reg.")
          ),

          # Actor type section
          div(class = "lgd-sep"),
          div(class = "legend-section-label", "Actor type"),
          div(class = "legend-item", id = "legend-type-ms",
            onclick = "toggleLegend('type','member_state',this)",
            tags$span(class = "lgd-sw lgd-circle", style = "background:#999;"),
            tags$span("Member State")
          ),
          div(class = "legend-item", id = "legend-type-ngo",
            onclick = "toggleLegend('type','observer_ngo',this)",
            tags$span(class = "lgd-sw lgd-square", style = "background:#999;"),
            tags$span("Observer NGO")
          ),
          div(class = "legend-item", id = "legend-type-isa",
            onclick = "toggleLegend('type','isa',this)",
            tags$span(class = "lgd-sw lgd-diamond", style = "background:#999;"),
            tags$span("ISA")
          ),
          div(class = "legend-item", id = "legend-type-oth",
            onclick = "toggleLegend('type','other',this)",
            tags$span(class = "lgd-tri", style = "border-bottom: 9px solid #999;"),
            tags$span("Other")
          ),

          # Reset button
          tags$button(class = "reset-filter-btn", onclick = "resetFilters()",
            HTML("&#8635;"), "Reset filters"
          )
        )
      ),

      # ── Actor comparison (right column on wide screens, below on narrow) ──
      div(class = "comparison-section",

        # Controls: title, hint, two dropdowns
        div(class = "comp-controls",
          div(class = "comp-section-label", "Actor Comparison"),
          div(class = "comp-hint", "Click actors in the graph, or choose below"),
          div(class = "comp-slot",
            span(class = "comparison-slot-badge slot-a-badge", "A"),
            div(style = "flex:1;",
              selectizeInput(
                "comp_actor_a", NULL,
                choices  = c("Choose actor" = "",
                             setNames(
                               sort(unique(dta_agg$actor)),
                               str_to_title(sort(unique(dta_agg$actor)))
                             )),
                selected = "",
                width    = "100%",
                options  = list(placeholder = "Choose actor")
              )
            )
          ),
          uiOutput("comp_scores_a"),
          div(class = "comp-slot",
            span(class = "comparison-slot-badge slot-b-badge", "B"),
            div(style = "flex:1;",
              selectizeInput(
                "comp_actor_b", NULL,
                choices  = c("Choose actor" = "",
                             setNames(
                               sort(unique(dta_agg$actor)),
                               str_to_title(sort(unique(dta_agg$actor)))
                             )),
                selected = "",
                width    = "100%",
                options  = list(placeholder = "Choose actor")
              )
            )
          ),
          uiOutput("comp_scores_b")
        ),

        # Chart
        div(class = "comp-chart-area",
          plotlyOutput("comp_plot_combined", height = "400px")
        )
      )
    ),

    # Toggle JS: client-side switch between network and 3D views
    tags$script(HTML("
      function toggleLegend(category, key, el) {
        el.classList.toggle('inactive');
        Shiny.setInputValue('legend_toggle', {category: category, key: key}, {priority: 'event'});
      }
      function resetFilters() {
        document.querySelectorAll('.legend-item.inactive').forEach(function(el) {
          el.classList.remove('inactive');
        });
        Shiny.setInputValue('reset_filter', Math.random(), {priority: 'event'});
      }
      document.addEventListener('DOMContentLoaded', function() {
        var btn     = document.getElementById('view-toggle-btn');
        var rstBtn  = document.getElementById('reset-view-btn');
        var net     = document.getElementById('net-plot-wrap');
        var sc3     = document.getElementById('sc3-plot-wrap');
        if (!btn) return;
        rstBtn.addEventListener('click', function() {
          // Reset plotly camera
          var plotEl = document.getElementById('scatter3d_plot');
          if (plotEl && window.Plotly) {
            Plotly.relayout(plotEl, {'scene.camera': {eye: {x:1.5, y:1.5, z:0.8}}});
          }
          // Reset network zoom/pan via Shiny
          Shiny.setInputValue('reset_view', Math.random(), {priority: 'event'});
        });
        var fsBtn = document.getElementById('fullscreen-btn');
        if (fsBtn) {
          fsBtn.addEventListener('click', function() {
            var section = document.querySelector('.network-section');
            if (!document.fullscreenElement) {
              section.requestFullscreen().catch(function() {});
            } else {
              document.exitFullscreen();
            }
          });
        }
        btn.addEventListener('click', function() {
          if (sc3.style.display === 'none') {
            net.style.display = 'none';
            sc3.style.display = '';
            btn.textContent = 'Switch to Network';
            setTimeout(function() {
              var plotEl = document.getElementById('scatter3d_plot');
              if (plotEl && window.Plotly) Plotly.Plots.resize(plotEl);
            }, 50);
          } else {
            sc3.style.display = 'none';
            net.style.display = '';
            btn.textContent = 'Switch to 3D';
          }
        });
      });
    ")),

    # Findings in paper column
    div(class = "paper paper-last",
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

  # Reset view (zoom/pan only)
  observeEvent(input$reset_view, {
    visNetworkProxy("network_plot") %>% visFit(animation = FALSE)
  })

  # Reset all filters (sliders + legend toggles + comparison)
  observeEvent(input$reset_filter, {
    legend_state$clusters   <- setNames(rep(TRUE, 5), as.character(1:5))
    legend_state$types      <- setNames(rep(TRUE, 4), c("member_state", "observer_ngo", "isa", "other"))
    comp_state$actor_a      <- NULL
    comp_state$actor_b      <- NULL
    comp_state$color_a      <- "#888888"
    comp_state$color_b      <- "#888888"
    comp_state$next_slot    <- "a"
    updateSelectizeInput(session, "comp_actor_a", selected = "")
    updateSelectizeInput(session, "comp_actor_b", selected = "")
  })

  # Legend toggle state
  legend_state <- reactiveValues(
    clusters = setNames(rep(TRUE, 5), as.character(1:5)),
    types    = setNames(rep(TRUE, 4), c("member_state", "observer_ngo", "isa", "other"))
  )
  observeEvent(input$legend_toggle, {
    tog <- input$legend_toggle
    if (tog$category == "cluster") {
      legend_state$clusters[tog$key] <- !legend_state$clusters[tog$key]
    } else {
      legend_state$types[tog$key] <- !legend_state$types[tog$key]
    }
  })

  # ── Comparison module ────────────────────────────────────────────────────

  # Helper: hex to rgba string
  hex_to_rgba <- function(hex, alpha = 1) {
    r <- strtoi(substr(hex, 2, 3), base = 16L)
    g <- strtoi(substr(hex, 4, 5), base = 16L)
    b <- strtoi(substr(hex, 6, 7), base = 16L)
    paste0("rgba(", r, ",", g, ",", b, ",", alpha, ")")
  }

  # Helper: look up the muted cluster color for an actor from net_nodes
  cluster_color_for_actor <- function(actor_name) {
    if (is.null(actor_name) || actor_name == "") return("#888888")
    node_id <- str_replace_all(actor_name, " ", "_")
    row <- net_nodes %>% filter(id == node_id, type != "vision")
    if (nrow(row) == 0) return("#888888")
    row$color[1]
  }

  comp_state <- reactiveValues(
    actor_a   = NULL,
    actor_b   = NULL,
    color_a   = "#888888",
    color_b   = "#888888",
    next_slot = "a"
  )

  # Assign actor to next comparison slot (alternates A/B/A/B)
  assign_comparison_actor <- function(actor_name) {
    if (comp_state$next_slot == "a") {
      comp_state$actor_a   <- actor_name
      comp_state$color_a   <- cluster_color_for_actor(actor_name)
      comp_state$next_slot <- "b"
      updateSelectizeInput(session, "comp_actor_a", selected = actor_name)
    } else {
      comp_state$actor_b   <- actor_name
      comp_state$color_b   <- cluster_color_for_actor(actor_name)
      comp_state$next_slot <- "a"
      updateSelectizeInput(session, "comp_actor_b", selected = actor_name)
    }
  }

  # Network node click -> comparison slot
  observeEvent(input$network_node_click, {
    node_id  <- input$network_node_click
    node_row <- net_nodes %>% filter(id == node_id)
    if (nrow(node_row) == 0 || node_row$type[1] == "vision") return()
    actor_name <- str_replace_all(node_id, "_", " ")
    assign_comparison_actor(actor_name)
  })

  # 3D scatter click -> comparison slot
  observeEvent(event_data("plotly_click", source = "scatter3d_src"), {
    ed <- event_data("plotly_click", source = "scatter3d_src")
    if (!is.null(ed) && length(ed$customdata) > 0) {
      actor_name <- ed$customdata[[1]]
      if (!is.null(actor_name) && !is.na(actor_name) && actor_name != "") {
        assign_comparison_actor(actor_name)
      }
    }
  })

  # Manual dropdown changes
  observeEvent(input$comp_actor_a, ignoreNULL = FALSE, {
    nm <- if (is.null(input$comp_actor_a) || input$comp_actor_a == "") NULL else input$comp_actor_a
    comp_state$actor_a <- nm
    comp_state$color_a <- cluster_color_for_actor(nm)
  })
  observeEvent(input$comp_actor_b, ignoreNULL = FALSE, {
    nm <- if (is.null(input$comp_actor_b) || input$comp_actor_b == "") NULL else input$comp_actor_b
    comp_state$actor_b <- nm
    comp_state$color_b <- cluster_color_for_actor(nm)
  })

  # Combined Radar chart builder
  output$comp_plot_combined <- renderPlotly({
    actor_a <- comp_state$actor_a
    actor_b <- comp_state$actor_b
    col_a   <- comp_state$color_a
    col_b   <- comp_state$color_b

    theta_cats <- c("Env. Cust.", "Mining Reg.", "MSR Inst.", "Env. Cust.")

    # Initialize plotly object
    p <- plot_ly()

    # Add max-extent faint boundary reference triangle [0, 1]
    p <- p %>% add_trace(
      type      = "scatterpolar",
      r         = c(1, 1, 1, 1),
      theta     = theta_cats,
      fill      = "toself",
      fillcolor = "rgba(240,240,240,0.05)",
      line      = list(color = "#dddddd", width = 1, dash = "dot"),
      mode      = "lines",
      hoverinfo = "none",
      showlegend = FALSE
    )

    # Trace for Actor A
    if (!is.null(actor_a) && actor_a != "") {
      arow_a <- dta_agg %>% filter(actor == actor_a)
      if (nrow(arow_a) > 0) {
        mr_a   <- arow_a$mean_mr2[1]
        si_a   <- arow_a$mean_si2[1]
        ec_a   <- arow_a$mean_ec2[1]
        fill_a <- hex_to_rgba(col_a, 0.17)

        p <- p %>% add_trace(
          type      = "scatterpolar",
          r         = c(ec_a, mr_a, si_a, ec_a),
          theta     = theta_cats,
          fill      = "toself",
          fillcolor = fill_a,
          line      = list(color = col_a, width = 2.5),
          mode      = "lines+markers",
          marker    = list(
            color = col_a, size = 8,
            line  = list(color = "#ffffff", width = 1.5)
          ),
          text      = paste0(
            "<b>", str_to_title(actor_a), "</b><br>",
            "Env. Cust.: ",  round(ec_a, 3), "<br>",
            "Mining Reg.: ", round(mr_a, 3), "<br>",
            "MSR Inst.: ",   round(si_a, 3)
          ),
          hoverinfo  = "text",
          showlegend = FALSE
        )
      }
    }

    # Trace for Actor B
    if (!is.null(actor_b) && actor_b != "") {
      arow_b <- dta_agg %>% filter(actor == actor_b)
      if (nrow(arow_b) > 0) {
        mr_b   <- arow_b$mean_mr2[1]
        si_b   <- arow_b$mean_si2[1]
        ec_b   <- arow_b$mean_ec2[1]
        fill_b <- hex_to_rgba(col_b, 0.17)

        p <- p %>% add_trace(
          type      = "scatterpolar",
          r         = c(ec_b, mr_b, si_b, ec_b),
          theta     = theta_cats,
          fill      = "toself",
          fillcolor = fill_b,
          line      = list(color = col_b, width = 2.5),
          mode      = "lines+markers",
          marker    = list(
            color = col_b, size = 8,
            line  = list(color = "#ffffff", width = 1.5)
          ),
          text      = paste0(
            "<b>", str_to_title(actor_b), "</b><br>",
            "Env. Cust.: ",  round(ec_b, 3), "<br>",
            "Mining Reg.: ", round(mr_b, 3), "<br>",
            "MSR Inst.: ",   round(si_b, 3)
          ),
          hoverinfo  = "text",
          showlegend = FALSE
        )
      }
    }

    # Layout and styling
    p %>% layout(
      polar = list(
        radialaxis  = list(range = c(0, 1), visible = TRUE, gridcolor = "#eeeeee", tickfont = list(size = 9, color = "#999999")),
        angularaxis = list(
          tickfont  = list(size = 11, family = "Lora, serif", color = "#333333"),
          linecolor = "#cccccc",
          gridcolor = "#eeeeee",
          direction = "clockwise",
          rotation  = 90
        ),
        bgcolor = "rgba(0,0,0,0)"
      ),
      showlegend    = FALSE,
      margin        = list(l = 55, r = 55, t = 30, b = 20),
      paper_bgcolor = "rgba(0,0,0,0)",
      plot_bgcolor  = "rgba(0,0,0,0)",
      font          = list(family = "Lora, serif", size = 10, color = "#333333")
    ) %>%
    config(displayModeBar = FALSE)
  })

  # Score readout blocks rendered below each dropdown
  make_score_ui <- function(actor_name, border_col, fill_col) {
    if (is.null(actor_name) || actor_name == "") return(NULL)
    arow <- dta_agg %>% filter(actor == actor_name)
    if (nrow(arow) == 0) return(NULL)
    scores <- list(
      list(lbl = "EC", val = round(arow$mean_ec2[1], 2)),
      list(lbl = "MR", val = round(arow$mean_mr2[1], 2)),
      list(lbl = "SI", val = round(arow$mean_si2[1], 2))
    )
    div(class = "comp-scores",
      style = paste0("border-left-color:", border_col, ";"),
      lapply(scores, function(s) {
        div(class = "comp-score-row",
          span(class = "comp-score-lbl", s$lbl),
          div(class = "comp-score-bar",
            div(class = "comp-score-fill",
              style = paste0("width:", round(s$val * 100), "%; background:", fill_col, ";")
            )
          ),
          span(class = "comp-score-val", s$val)
        )
      })
    )
  }

  output$comp_scores_a <- renderUI({
    col <- comp_state$color_a
    make_score_ui(comp_state$actor_a, col, hex_to_rgba(col, 0.45))
  })
  output$comp_scores_b <- renderUI({
    col <- comp_state$color_b
    make_score_ui(comp_state$actor_b, col, hex_to_rgba(col, 0.45))
  })

  # ── End comparison module ─────────────────────────────────────────────────

  # 3D vision-space scatter
  output$scatter3d_plot <- renderPlotly({

    cluster_cols  <- c("1" = "#6DB589", "2" = "#BC7798", "3" = "#5BAAB6",
                       "4" = "#CC8A52", "5" = "#8A7ABF")
    cluster_names <- c("1" = "Env. Custodian", "2" = "MR + Env. Cust.",
                       "3" = "EC + MSR", "4" = "Mining Reg.", "5" = "Mixed")
    type_syms     <- c("Member State" = "circle", "Observer NGO" = "square",
                       "ISA"          = "diamond", "Other"        = "cross")

    active_clusters <- names(which(legend_state$clusters))
    active_types    <- names(which(legend_state$types))

    df <- dta_agg %>%
      filter(!is.na(mean_mr2), !is.na(mean_si2), !is.na(mean_ec2)) %>%
      mutate(actor_id = str_replace_all(actor, " ", "_")) %>%
      left_join(raw_nodes %>% select(id, cluster5), by = c("actor_id" = "id")) %>%
      mutate(
        cluster_key  = as.character(if_else(is.na(cluster5), 1L, as.integer(cluster5))),
        type_key_leg = case_when(
          actor_type_eh2 == "member state" | actor == "african group" ~ "member_state",
          actor_type_eh2 == "observer ngo"                            ~ "observer_ngo",
          actor_type_eh2 == "isa"                                     ~ "isa",
          TRUE                                                         ~ "other"
        )
      ) %>%
      filter(cluster_key %in% active_clusters, type_key_leg %in% active_types) %>%
      mutate(
        label       = str_to_title(actor),
        type_clean  = case_when(
          actor_type_eh2 == "member state" | actor == "african group" ~ "Member State",
          actor_type_eh2 == "observer ngo"                            ~ "Observer NGO",
          actor_type_eh2 == "isa"                                     ~ "ISA",
          TRUE                                                         ~ "Other"
        ),
        point_sym = type_syms[type_clean],
        hover = paste0(
          "<b>", str_to_title(actor), "</b><br>",
          "Mining Reg.: <b>", round(mean_mr2, 3), "</b><br>",
          "MSR Inst.:   <b>", round(mean_si2, 3), "</b><br>",
          "Env. Cust.:  <b>", round(mean_ec2, 3), "</b>"
        )
      )

    # Expose comparison state as reactive dependency so highlights re-render
    comp_a <- comp_state$actor_a
    comp_b <- comp_state$actor_b

    p <- plot_ly(source = "scatter3d_src")

    # One trace per cluster: colour from cluster, symbol from actor type
    for (cl in c("1", "2", "3", "4", "5")) {
      cl_df <- df %>% filter(cluster_key == cl)
      if (nrow(cl_df) == 0) next
      p <- p %>% add_trace(
        data          = cl_df,
        x = ~mean_mr2, y = ~mean_si2, z = ~mean_ec2,
        type          = "scatter3d",
        mode          = "markers+text",
        name          = cluster_names[cl],
        legendgroup   = paste0("cl", cl),
        customdata    = ~actor,
        marker        = list(
          color   = cluster_cols[cl],
          symbol  = ~point_sym,
          size    = 10,
          opacity = 0.88,
          line    = list(width = 0.8, color = "rgba(255,255,255,0.5)")
        ),
        text          = ~label,
        textposition  = "top center",
        textfont      = list(size = 10, color = "#333333", family = "Lora, serif"),
        hovertext     = ~hover,
        hoverinfo     = "text",
        showlegend    = TRUE
      )
    }

    # Highlighted traces for comparison actors (drawn on top, visible even if filtered)
    comp_highlight_list <- list(
      list(actor = comp_a, color = comp_state$color_a),
      list(actor = comp_b, color = comp_state$color_b)
    )
    for (hl in comp_highlight_list) {
      if (!is.null(hl$actor) && hl$actor != "") {
        hl_row <- dta_agg %>%
          filter(actor == hl$actor, !is.na(mean_mr2), !is.na(mean_si2), !is.na(mean_ec2))
        if (nrow(hl_row) > 0) {
          hl_sym <- case_when(
            hl_row$actor_type_eh2[1] == "member state" | hl_row$actor[1] == "african group" ~ "circle",
            hl_row$actor_type_eh2[1] == "observer ngo" ~ "square",
            hl_row$actor_type_eh2[1] == "isa"          ~ "diamond",
            TRUE                                        ~ "cross"
          )
          p <- p %>% add_trace(
            x = hl_row$mean_mr2, y = hl_row$mean_si2, z = hl_row$mean_ec2,
            type      = "scatter3d",
            mode      = "markers",
            marker    = list(
              color   = hl$color,
              symbol  = hl_sym,
              size    = 15,
              opacity = 1,
              line    = list(width = 3, color = "#ffffff")
            ),
            hovertext = paste0("<b>", str_to_title(hl_row$actor[1]), "</b>"),
            hoverinfo = "text",
            showlegend = FALSE
          )
        }
      }
    }

    # Dummy traces for actor-type shape legend (grey, no data)
    for (tp in names(type_syms)) {
      p <- p %>% add_trace(
        x = NA_real_, y = NA_real_, z = NA_real_,
        type        = "scatter3d",
        mode        = "markers",
        name        = tp,
        legendgroup = tp,
        marker      = list(color = "#777", symbol = type_syms[tp], size = 9),
        hoverinfo   = "none",
        showlegend  = TRUE
      )
    }

    p %>% layout(
      scene = list(
        xaxis = list(title = "Mining Reg.", range = c(1, 0),
                     tickfont = list(size = 10), titlefont = list(size = 11),
                     gridcolor = "#e8e8e8", zerolinecolor = "#cccccc"),
        yaxis = list(title = "MSR Inst.",   range = c(1, 0),
                     tickfont = list(size = 10), titlefont = list(size = 11),
                     gridcolor = "#e8e8e8", zerolinecolor = "#cccccc"),
        zaxis = list(title = "Env. Cust.",  range = c(0, 1),
                     tickfont = list(size = 10), titlefont = list(size = 11),
                     gridcolor = "#e8e8e8", zerolinecolor = "#cccccc"),
        bgcolor = "#ffffff",
        camera  = list(eye = list(x = 1.5, y = 1.5, z = 0.8))
      ),
      uirevision  = "stable",
      showlegend = FALSE,
      margin        = list(l = 0, r = 0, t = 0, b = 80),
      paper_bgcolor = "#ffffff",
      font          = list(family = "Lora, serif", color = "#333333")
    ) %>%
    config(displayModeBar = FALSE)
  })
  outputOptions(output, "scatter3d_plot", suspendWhenHidden = FALSE)

  # Network: render once with all nodes; proxy updates hidden property on slider change
  # (avoids zoom reset that a full re-render would cause)
  output$network_plot <- renderVisNetwork({
    initial_nodes <- net_nodes %>%
      mutate(
        color.border = if_else(type == "vision", "#b5b5b5", "rgba(0,0,0,0.15)"),
        borderWidth  = if_else(type == "vision", 1.2, 1)
      )

    visNetwork(initial_nodes, net_edges) %>%
      visNodes(
        color = list(
          highlight = list(background = "#444444", border = "#111111"),
          hover     = list(background = "#555555", border = "#111111")
        )
      ) %>%
      visEdges(
        smooth = FALSE,
        color  = list(color = "rgba(0,0,0,0.07)", highlight = "rgba(0,0,0,0.3)")
      ) %>%
      visOptions(
        highlightNearest = FALSE,
        nodesIdSelection = FALSE
      ) %>%
      visPhysics(enabled = FALSE) %>%
      visInteraction(
        navigationButtons = FALSE,
        zoomView          = TRUE,
        dragView          = TRUE,
        tooltipDelay      = 100
      ) %>%
      visEvents(click = "function(params) {
        if (params.nodes.length > 0) {
          Shiny.setInputValue('network_node_click', params.nodes[0], {priority: 'event'});
        }
      }")
  })

  observe({
    active_clusters <- names(which(legend_state$clusters))
    active_types    <- names(which(legend_state$types))

    nodes_update <- net_nodes %>%
      mutate(
        cluster_key  = as.character(cluster5),
        type_key_leg = case_when(
          type == "vision"                                          ~ NA_character_,
          actor_type_eh2 == "member state" | id == "african_group" ~ "member_state",
          actor_type_eh2 == "observer ngo"                         ~ "observer_ngo",
          actor_type_eh2 == "isa"                                  ~ "isa",
          TRUE                                                      ~ "other"
        )
      ) %>%
      transmute(
        id,
        hidden = !(
          type == "vision" |
          ((is.na(cluster_key)  | cluster_key  %in% active_clusters) &
           (is.na(type_key_leg) | type_key_leg %in% active_types))
        )
      )

    visNetworkProxy("network_plot") %>%
      visUpdateNodes(nodes = nodes_update)
  })

  # Highlight comparison-selected actors in network with cluster-coloured borders
  observe({
    a_id  <- if (!is.null(comp_state$actor_a)) str_replace_all(comp_state$actor_a, " ", "_") else ""
    b_id  <- if (!is.null(comp_state$actor_b)) str_replace_all(comp_state$actor_b, " ", "_") else ""
    col_a <- comp_state$color_a
    col_b <- comp_state$color_b

    nodes_hl <- net_nodes %>%
      transmute(
        id,
        color.border = case_when(
          a_id != "" & id == a_id ~ col_a,
          b_id != "" & id == b_id ~ col_b,
          type == "vision"        ~ "#b5b5b5",
          TRUE                    ~ "rgba(0,0,0,0.15)"
        ),
        borderWidth = case_when(
          (a_id != "" & id == a_id) | (b_id != "" & id == b_id) ~ 2,
          type == "vision"        ~ 1.2,
          TRUE                    ~ 1
        )
      )

    visNetworkProxy("network_plot") %>%
      visUpdateNodes(nodes = nodes_hl)
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
