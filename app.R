

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

/* Network: full-width outer container (slight side margins), responsive flex */
.network-section {
  margin: 2rem 1.5rem 0;
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
/* Dim backdrop behind the fullscreen popup (injected by JS) */
.fs-backdrop {
  display: none;
  position: fixed;
  top: 0; left: 0; right: 0; bottom: 0;
  z-index: 9998;
  background: rgba(0,0,0,0.30);
  cursor: default;
}
.fs-backdrop.active { display: block; }
/* Fullscreen popup: fills the viewport (minus margin), plots resize to fit */
.net-canvas-box.is-fullscreen {
  position: fixed !important;
  top: 2.5rem !important; left: 2.5rem !important;
  right: 2.5rem !important; bottom: 2.5rem !important;
  width: auto !important;
  height: auto !important;
  z-index: 9999;
  border: 1px solid #bbb !important;
  border-radius: 4px !important;
  box-shadow: 0 12px 48px rgba(0,0,0,0.22), 0 2px 8px rgba(0,0,0,0.10) !important;
  overflow: hidden;
  background: #fff;
}
/* Inner flex chain must fill the popup height */
.net-canvas-box.is-fullscreen .net-plot-area { overflow: hidden; }
.net-canvas-box.is-fullscreen #net-plot-wrap,
.net-canvas-box.is-fullscreen #sc3-plot-wrap { overflow: hidden; }
/* Fullscreen button icon swaps to inward arrows when popup is open */
.net-canvas-box.is-fullscreen .fs-icon-open  { display: none !important; }
.net-canvas-box.is-fullscreen .fs-icon-close { display: inline-flex !important; }
/* Fullscreen button stays visible in fullscreen (acts as exit toggle) */
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
/* slot-a-badge / slot-b-badge colors now rendered server-side via uiOutput */

/* Data tab: no internal card scroll — let the page scroll */
.data-tab {
  padding: 2rem 1.5rem 4rem;
}
.data-tab .bslib-card,
.data-tab .card {
  overflow: visible !important;
  max-height: none !important;
  height: auto !important;
  flex: none !important;
  display: block !important;
}
.data-tab .card-body {
  overflow: visible !important;
  max-height: none !important;
  height: auto !important;
  flex: none !important;
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
/* Selected rows: match their odd/even background so clicks leave no colour trace */
.data-tab table.dataTable tbody tr.odd.selected > td,
.data-tab table.dataTable tbody tr.odd.selected {
  background-color: #fafafa !important;
  color: #333 !important;
  box-shadow: none !important;
}
.data-tab table.dataTable tbody tr.even.selected > td,
.data-tab table.dataTable tbody tr.even.selected {
  background-color: #fff !important;
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

/* visNetwork tooltip: match paper aesthetic */
div.vis-tooltip {
  background: #ffffff !important;
  border: 1px solid #ddd !important;
  border-radius: 3px !important;
  box-shadow: 0 2px 8px rgba(0,0,0,0.10) !important;
  font-family: 'Lora', Georgia, serif !important;
  font-size: 0.82rem !important;
  color: #222 !important;
  padding: 0.4rem 0.65rem !important;
  max-width: 240px !important;
  line-height: 1.5 !important;
}

/* View-statements link in comp score block */
.comp-stmts-link {
  font-size: 0.68rem;
  color: #bbb;
  text-decoration: none;
  cursor: pointer;
  border: none;
  background: none;
  font-family: inherit;
  padding: 0.2rem 0 0;
  text-align: left;
  display: inline-flex;
  align-items: center;
  gap: 0.25rem;
  letter-spacing: 0.04em;
  margin-top: 0.05rem;
  transition: color 0.12s;
}
.comp-stmts-link:hover { color: #555; }
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
        tags$p(class = "subtitle", HTML('Paper by Emil W. Hildebrand and Alice B. M. Vadrot | <a href="http://twinpolitics.eu" target="_blank" style="color:inherit;">ERC TwinPolitics project</a>, 2026'))
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

        # Plot area
        div(class = "net-plot-area",
          div(class = "view-btn-group",
            tags$button(id = "reset-view-btn",  class = "reset-view-btn",  title = "Reset view",  bs_icon("aspect-ratio")),
            tags$button(id = "view-toggle-btn", class = "view-toggle-btn", title = "Switch view", "Switch to 3D"),
            # Dual-icon fullscreen button: open icon swaps to contract icon when popup is active
            tags$button(id = "fullscreen-btn", class = "fullscreen-btn", title = "Fullscreen",
              tags$span(class = "fs-icon-open",  style = "display:inline-flex;", bs_icon("arrows-fullscreen")),
              tags$span(class = "fs-icon-close", style = "display:none;",        bs_icon("arrows-angle-contract"))
            )
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
            uiOutput("badge_a"),
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
            uiOutput("badge_b"),
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
      Shiny.addCustomMessageHandler('goto_statements', function(msg) {
        // Navigate to the Data top-level tab
        var dataTab = document.querySelector('[data-bs-toggle=\"tab\"][data-value=\"Data\"]');
        if (dataTab) dataTab.click();
        // Then switch to the Statements sub-tab (after a short delay for the tab to render)
        setTimeout(function() {
          var stmtTab = document.querySelector('[data-bs-toggle=\"tab\"][data-value=\"Statements\"]');
          if (stmtTab) stmtTab.click();
        }, 200);
      });

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
        // Backdrop div: clicking it exits fullscreen (default cursor, no hand)
        var backdrop = document.createElement('div');
        backdrop.className = 'fs-backdrop';
        document.body.appendChild(backdrop);

        var savedPlotHeight = '600px';
        var PLOT_RATIO = 0.70; // height = 70% of plot-area width (≈ 600px at original sizes)

        function setPlotHeights(h) {
          var netDiv = document.getElementById('network_plot');
          if (netDiv) netDiv.style.height = h;
          var sc3Div = document.getElementById('scatter3d_plot');
          if (sc3Div) {
            sc3Div.style.height = h;
            if (window.Plotly) Plotly.Plots.resize(sc3Div);
          }
        }

        // Recalculate height proportionally from current plot-area width
        function updateNetworkHeight() {
          var canvas = document.querySelector('.net-canvas-box');
          if (!canvas || canvas.classList.contains('is-fullscreen')) return;
          var plotArea = document.querySelector('.net-plot-area');
          if (!plotArea) return;
          var w = plotArea.clientWidth;
          if (w <= 0) return;
          var h = Math.max(320, Math.round(w * PLOT_RATIO)) + 'px';
          savedPlotHeight = h;
          setPlotHeights(h);
        }

        // Debounced resize listener
        var resizeTimer;
        window.addEventListener('resize', function() {
          clearTimeout(resizeTimer);
          resizeTimer = setTimeout(updateNetworkHeight, 100);
        });

        function exitFullscreen() {
          var canvas = document.querySelector('.net-canvas-box');
          canvas.classList.remove('is-fullscreen');
          backdrop.classList.remove('active');
          // Recalculate proportional height rather than restoring a stale value
          updateNetworkHeight();
        }
        function enterFullscreen() {
          var canvas = document.querySelector('.net-canvas-box');
          canvas.classList.add('is-fullscreen');
          backdrop.classList.add('active');
          // Stretch plots to fill the popup once CSS has settled
          setTimeout(function() {
            setPlotHeights(canvas.clientHeight + 'px');
          }, 50);
        }
        backdrop.addEventListener('click', exitFullscreen);

        var fsBtn = document.getElementById('fullscreen-btn');
        if (fsBtn) {
          fsBtn.addEventListener('click', function() {
            var canvas = document.querySelector('.net-canvas-box');
            if (canvas.classList.contains('is-fullscreen')) {
              exitFullscreen();
            } else {
              enterFullscreen();
            }
          });
        }
        // Exit on Escape key
        document.addEventListener('keydown', function(e) {
          if (e.key === 'Escape') exitFullscreen();
        });
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


  # ── Tab 2: Documentation ====================================================
  nav_panel("Documentation", icon = bs_icon("book")),

  # ── Tab 3: Data =============================================================
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

  # Navigate to Statements tab filtered by actor
  observeEvent(input$goto_stmts, {
    actor_nm <- input$goto_stmts
    if (!is.null(actor_nm) && actor_nm != "") {
      # Match case-insensitively so dta_agg and gpt_results actor names always line up
      matched <- gpt_results$actor[tolower(gpt_results$actor) == tolower(actor_nm)]
      sel <- if (length(matched) > 0) matched[1] else "All"
      updateSelectizeInput(session, "gpt_actor", selected = sel)
      session$sendCustomMessage("goto_statements", list())
    }
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

  # Helper: darken a hex color by multiplying RGB channels by factor
  darken_hex <- function(hex, factor = 0.6) {
    r <- min(255L, round(strtoi(substr(hex, 2, 3), base = 16L) * factor))
    g <- min(255L, round(strtoi(substr(hex, 4, 5), base = 16L) * factor))
    b <- min(255L, round(strtoi(substr(hex, 6, 7), base = 16L) * factor))
    sprintf("#%02X%02X%02X", r, g, b)
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
          text = c(
            paste0("<b>", str_to_title(actor_a), "</b><br>Env. Cust.: ",  round(ec_a, 3)),
            paste0("<b>", str_to_title(actor_a), "</b><br>Mining Reg.: ", round(mr_a, 3)),
            paste0("<b>", str_to_title(actor_a), "</b><br>MSR Inst.: ",   round(si_a, 3)),
            paste0("<b>", str_to_title(actor_a), "</b><br>Env. Cust.: ",  round(ec_a, 3))
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
          text = c(
            paste0("<b>", str_to_title(actor_b), "</b><br>Env. Cust.: ",  round(ec_b, 3)),
            paste0("<b>", str_to_title(actor_b), "</b><br>Mining Reg.: ", round(mr_b, 3)),
            paste0("<b>", str_to_title(actor_b), "</b><br>MSR Inst.: ",   round(si_b, 3)),
            paste0("<b>", str_to_title(actor_b), "</b><br>Env. Cust.: ",  round(ec_b, 3))
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
      }),
      tags$button(
        class   = "comp-stmts-link",
        onclick = paste0("Shiny.setInputValue('goto_stmts','", actor_name, "',{priority:'event'});"),
        bs_icon("arrow-right-short"), "View statements"
      )
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

  # Dynamic A/B slot badges — adopt the actor's cluster color
  output$badge_a <- renderUI({
    col <- comp_state$color_a
    tags$span(class = "comparison-slot-badge",
      style = paste0("background:", hex_to_rgba(col, 0.15), "; color:", col, ";"),
      "A")
  })
  output$badge_b <- renderUI({
    col <- comp_state$color_b
    tags$span(class = "comparison-slot-badge",
      style = paste0("background:", hex_to_rgba(col, 0.15), "; color:", col, ";"),
      "B")
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

    # NOTE: comp_state is NOT a reactive dep here — comparison highlights are
    # updated separately via plotlyProxy so actor clicks never reset the camera.
    p <- plot_ly(source = "scatter3d_src")

    # Traces 0-4: one per cluster, always emitted (even if empty after filtering).
    # Fixed trace count is required so plotlyProxy restyle can target stable indices.
    for (cl in c("1", "2", "3", "4", "5")) {
      cl_df <- df %>% filter(cluster_key == cl)
      if (nrow(cl_df) == 0) {
        # Empty placeholder — invisible but holds the index
        p <- p %>% add_trace(
          x = NA_real_, y = NA_real_, z = NA_real_,
          type        = "scatter3d",
          mode        = "markers",
          name        = cluster_names[cl],
          legendgroup = paste0("cl", cl),
          marker      = list(color = cluster_cols[cl], size = 10, opacity = 0),
          hoverinfo   = "none",
          showlegend  = FALSE
        )
      } else {
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
    }

    # Traces 5-8: dummy actor-type shape legend entries (grey, no data)
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

    # Traces 9-10: comparison highlight placeholders (initially invisible).
    # Updated by the plotlyProxy observe below without triggering a full re-render.
    for (i in seq_len(2)) {
      p <- p %>% add_trace(
        x = NA_real_, y = NA_real_, z = NA_real_,
        type       = "scatter3d",
        mode       = "markers",
        marker     = list(color = "#888888", symbol = "circle", size = 15, opacity = 0,
                          line = list(width = 2, color = "#ffffff")),
        hoverinfo  = "none",
        showlegend = FALSE
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
        bgcolor     = "#ffffff",
        camera      = list(eye = list(x = 1.5, y = 1.5, z = 0.8)),
        uirevision  = "stable"
      ),
      showlegend = FALSE,
      margin        = list(l = 0, r = 0, t = 0, b = 80),
      paper_bgcolor = "#ffffff",
      font          = list(family = "Lora, serif", color = "#333333")
    ) %>%
    config(displayModeBar = FALSE)
  })
  outputOptions(output, "scatter3d_plot", suspendWhenHidden = FALSE)

  # Update 3D comparison highlights (traces 9-10) via proxy — no camera reset
  observe({
    comp_a <- comp_state$actor_a
    comp_b <- comp_state$actor_b
    col_a  <- comp_state$color_a
    col_b  <- comp_state$color_b

    type_syms_hl <- c(
      "member state" = "circle", "observer ngo" = "square",
      "isa"          = "diamond", "other"        = "cross"
    )

    actor_sym <- function(actor_name) {
      row <- dta_agg %>% filter(actor == actor_name)
      if (nrow(row) == 0) return("circle")
      key <- case_when(
        row$actor_type_eh2[1] == "member state" | row$actor[1] == "african group" ~ "member state",
        row$actor_type_eh2[1] == "observer ngo" ~ "observer ngo",
        row$actor_type_eh2[1] == "isa"          ~ "isa",
        TRUE                                     ~ "other"
      )
      type_syms_hl[key]
    }

    hl_vals <- function(actor_name, color) {
      if (is.null(actor_name) || actor_name == "") {
        return(list(x = NA_real_, y = NA_real_, z = NA_real_,
                    color = color, sym = "circle", opacity = 0, ht = ""))
      }
      row <- dta_agg %>% filter(actor == actor_name, !is.na(mean_mr2))
      if (nrow(row) == 0) {
        return(list(x = NA_real_, y = NA_real_, z = NA_real_,
                    color = color, sym = "circle", opacity = 0, ht = ""))
      }
      list(
        x       = row$mean_mr2[1],
        y       = row$mean_si2[1],
        z       = row$mean_ec2[1],
        color   = color,
        sym     = unname(actor_sym(actor_name)),
        opacity = 1,
        ht      = paste0("<b>", str_to_title(actor_name), "</b>")
      )
    }

    a <- hl_vals(comp_a, col_a)
    b <- hl_vals(comp_b, col_b)

    plotlyProxy("scatter3d_plot", session) %>%
      plotlyProxyInvoke("restyle",
        list(
          x                = list(list(a$x), list(b$x)),
          y                = list(list(a$y), list(b$y)),
          z                = list(list(a$z), list(b$z)),
          "marker.color"   = list(a$color,   b$color),
          "marker.symbol"  = list(a$sym,     b$sym),
          "marker.opacity" = list(a$opacity, b$opacity),
          hovertext        = list(a$ht,      b$ht),
          hoverinfo        = list("text",    "text")
        ),
        list(9L, 10L)
      )
  })

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

  # Highlight comparison-selected actors in network with darkened cluster-coloured borders
  observe({
    a_id  <- if (!is.null(comp_state$actor_a)) str_replace_all(comp_state$actor_a, " ", "_") else ""
    b_id  <- if (!is.null(comp_state$actor_b)) str_replace_all(comp_state$actor_b, " ", "_") else ""
    # Darken the cluster color so the border stands out against the node fill
    col_a <- darken_hex(comp_state$color_a, 0.55)
    col_b <- darken_hex(comp_state$color_b, 0.55)

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
          $ctrl.find('.dataTables_filter').remove();
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
