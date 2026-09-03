

source("global.R")

# ── CSS =======================================================================
css <- "
*, *::before, *::after { border-radius: 0 !important; }
* { font-family: 'Times New Roman', Times, serif !important; }
html { font-size: 112% !important; }
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
  color: #222 !important;
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
  max-width: 1100px;
  margin: 0 auto;
  padding: 2.5rem 1.5rem 1.25rem;
}
.paper-last {
  padding-top: 3.5rem;
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
  font-size: 1.15rem;
  color: #222;
  font-style: normal;
  margin: 0;
}

.paper p {
  font-size: 1.1rem;
  line-height: 1.92;
  color: #222;
  margin: 0 0 0.9rem;
}
.paper h2 {
  font-size: 1.5rem;
  font-weight: 700;
  color: #1a1a2e;
  margin: 1.6rem 0 0.5rem;
  line-height: 1.35;
}
.paper h3 {
  font-size: 1.2rem;
  font-weight: 700;
  color: #1a1a2e;
  margin: 1.4rem 0 0.4rem;
  line-height: 1.4;
}
.paper h4 {
  font-size: 1.2rem;
  font-weight: 700;
  font-style: italic;
  color: #1a1a2e;
  margin: 1.4rem 0 0.4rem;
  line-height: 1.4;
}

/* Network: full-width outer container (slight side margins), responsive flex */
.network-section {
  margin: 0.75rem 1.5rem 0;
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
.net-plot-area {
  flex: 1;
  min-width: 0;
  position: relative;
  padding: 0.4rem;
}
/* Floor: keeps the network canvas tall enough that the comparison panel (300px chart
   + ~320px controls incl. empty score rows × 2) never pushes the outer box above the
   vis.js canvas height. CSS min-height wins even when JS sets an explicit height. */
#network_plot { min-height: 640px; }

/* ── Legend: CSS-swatch overhaul ─────────────────────────────────────── */
.net-legend-side {
  width: 190px;
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
  color: #222;
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
  white-space: nowrap;
}
.legend-item:hover { opacity: 0.55; }
.legend-item.inactive { opacity: 0.2; }
.legend-item.inactive:hover { opacity: 0.4; }
.legend-static {
  display: flex;
  align-items: center;
  gap: 0.45rem;
  font-size: 0.8rem;
  color: #444;
  line-height: 1.65;
  padding: 0.04rem 0.15rem;
  font-style: italic;
}
.lgd-sep { border: none; border-top: 1px solid #f0f0f0; margin: 0.55rem 0 0.45rem; }
.lgd-sw { display: inline-block; width: 9px; height: 9px; flex-shrink: 0; margin-top: 0.06rem; }
.lgd-circle { border-radius: 50%; }
.lgd-square { border-radius: 1px; }
.lgd-diamond { border-radius: 1px; transform: rotate(45deg); width: 8px; height: 8px; }
.lgd-hexagon { clip-path: polygon(50% 0%, 100% 25%, 100% 75%, 50% 100%, 0% 75%, 0% 25%); }
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
  color: #222;
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
.reset-filter-btn:hover { color: #000; }
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
.reset-view-btn {
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
.reset-view-btn:hover { background: #f5f5f5; }
/* Collapse tab: handle strip on the inner edge of the comparison panel */
.comp-collapse-tab {
  flex-shrink: 0;
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  color: #aaa;
  background: #f5f5f5;
  transition: color 0.15s, background 0.15s;
  user-select: none;
}
.comp-collapse-tab:hover { color: #444; background: #ebebeb; }
/* Collapse tab: vertical strip on the left edge of the comparison panel */
.comp-collapse-tab { width: 22px; border-right: 1px solid #ddd; }
/* Chevron: right = collapse panel, left = expand */
.comp-tab-icon { display: inline-flex; font-size: 0.78rem; }
.comp-tab-expand { display: none; }
.comparison-section.is-collapsed .comp-tab-collapse { display: none; }
.comparison-section.is-collapsed .comp-tab-expand   { display: inline-flex; }
.ctrl-label {
  font-size: 0.68rem;
  font-weight: 800;
  letter-spacing: 0.1em;
  text-transform: uppercase;
  color: #222;
  margin-bottom: 0.4rem;
}

/* Section divider */
.sec-divider { border: none; border-top: 1px solid #bbb; margin: 1.6rem 0; }

/* Finding sections: stacked layout (label → heading → text → chart) */
.finding { margin-bottom: 0.5rem; }
.finding-chart-wrap {
  margin-left: 8%;
  margin-right: 8%;
}

/* Two-column grid for Finding 2 side-by-side charts */
.finding-chart-grid {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 0 2rem;
  margin-top: 1rem;
}
.finding-chart-panel {}
.chart-sublabel {
  font-size: 0.72rem;
  font-weight: 700;
  letter-spacing: 0.09em;
  text-transform: uppercase;
  color: #222;
  margin: 0 0 0.3rem;
}

/* Map section */
.finding-map-container {
  margin-top: 1.2rem;
  margin-left: -1.5rem;
  margin-right: -1.5rem;
  border: 1px solid #e0e0e0;
  border-radius: 3px;
  /* no overflow:hidden — it clips Leaflet tile loading and label tooltips */
}

/* Ensure polygon hover events are never blocked by inherited CSS (macOS/WebKit).
   Only target individual interactive paths — NOT the SVG root element.
   Leaflet sets pointer-events:none on the SVG root intentionally; overriding it
   makes the SVG container fire spurious mouseout events that close tooltips. */
.leaflet-interactive { pointer-events: visiblePainted !important; }

/* White ocean background */
.leaflet-container { background: #ffffff !important; }

/* Flat zoom control */
.leaflet-control-zoom {
  border: 1px solid #e0e0e0 !important;
  border-radius: 3px !important;
  box-shadow: none !important;
}
.leaflet-control-zoom a {
  color: #555 !important;
  font-family: inherit;
  line-height: 26px !important;
  border-bottom-color: #e0e0e0 !important;
}
.leaflet-control-zoom a:hover { background: #f5f5f5 !important; }

/* Flat legend */
.leaflet-control.info.legend {
  background: rgba(255,255,255,0.96) !important;
  border: 1px solid #e0e0e0 !important;
  border-radius: 3px !important;
  box-shadow: none !important;
  padding: 0.45rem 0.7rem 0.5rem !important;
  font-family: 'Times New Roman', Times, serif !important;
  font-size: 0.76rem !important;
  color: #222 !important;
  line-height: 1.5 !important;
}
.leaflet-control.info.legend .legend-title {
  font-weight: 700 !important;
  font-size: 0.68rem !important;
  letter-spacing: 0.09em !important;
  text-transform: uppercase !important;
  color: #444 !important;
  display: block !important;
  margin-bottom: 0.3rem !important;
}
/* Hide CARTO attribution link color */
.leaflet-control-attribution a { color: #aaa !important; }
.leaflet-control-attribution { font-size: 0.65rem !important; color: #bbb !important; }

/* Pill-style vision toggle buttons for the map */
.map-toggle {
  padding: 0.6rem 0.9rem 0;
  background: #fff;
  border-bottom: 1px solid #eee;
}
.map-toggle .shiny-input-container { margin: 0; }
.map-toggle label.control-label    { display: none; }
.map-toggle .shiny-options-group   { display: flex; gap: 0; }
.map-toggle label.radio-inline {
  display: inline-flex;
  align-items: center;
  padding: 0.22rem 0.85rem;
  font-size: 0.78rem;
  font-weight: 600;
  letter-spacing: 0.03em;
  color: #999;
  border: 1px solid #e0e0e0;
  cursor: pointer;
  background: #fff;
  transition: color 0.12s, background 0.12s;
  margin: 0 0 0.6rem;
  line-height: 1.6;
}
.map-toggle label.radio-inline:first-child { border-radius: 3px 0 0 3px; }
.map-toggle label.radio-inline:last-child  { border-radius: 0 3px 3px 0; }
.map-toggle label.radio-inline + label.radio-inline { border-left: none; }
.map-toggle label.radio-inline:has(input[type=radio]:checked) {
  background: #ebebeb;
  color: #444;
  border-color: #c8c8c8;
}
.map-toggle label.radio-inline:hover:not(:has(input[type=radio]:checked)) {
  background: #f5f5f5;
  color: #555;
}
.map-toggle input[type=radio] { display: none; }

.finding-label {
  font-size: 0.7rem;
  font-weight: 800;
  letter-spacing: 0.13em;
  text-transform: uppercase;
  color: #bbb;
  margin-bottom: 0.25rem;
}
.finding h3 {
  font-size: 1.3rem;
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
  margin: 0.5rem -3rem 1.5rem;
}
.vision-card {
  border: 4px solid #ddd;
  padding: 0.5rem 0.85rem;
  cursor: pointer;
  transition: border-color 0.15s, background 0.15s;
  border-radius: 0 2px 2px 0;
}
.vision-card:hover {
  border-color: #1a1a2e;
  background: #f9f9f9;
}
.vision-card-mr          { border-color: #CC8A52; }
.vision-card-mr h4       { color: #CC8A52; }
.vision-card-mr:hover    { border-color: #CC8A52; background: rgba(204,138,82,0.07); }
.vision-card-si          { border-color: #5BAAB6; }
.vision-card-si h4       { color: #5BAAB6; }
.vision-card-si:hover    { border-color: #5BAAB6; background: rgba(91,170,182,0.07); }
.vision-card-ec          { border-color: #6DB589; }
.vision-card-ec h4       { color: #6DB589; }
.vision-card-ec:hover    { border-color: #6DB589; background: rgba(109,181,137,0.07); }
.vision-card h4 {
  font-size: 0.78rem;
  font-weight: 700;
  text-transform: uppercase;
  letter-spacing: 0.06em;
  color: #1a1a2e;
  margin: 0 0 0.35rem;
}
.vision-card .read-more-hint {
  font-size: 0.7rem;
  color: #444;
  margin-top: 0.3rem;
  letter-spacing: 0.03em;
}
.vision-card:hover .read-more-hint { color: #222; }
.vision-card p {
  font-size: 0.82rem;
  line-height: 1.65;
  color: #222;
  margin: 0;
}

/* ── Actor Comparison Module ─────────────────────────────────────────────── */
.comparison-section {
  display: flex;
  flex-shrink: 0;
  background: #fff;
}
/* Comparison: fixed right column — row so the collapse tab runs full height */
.comparison-section { width: 340px; flex-direction: row; }
/* Inner column: controls stacked above chart, fills remaining width.
   Explicit width (panel minus the 22px tab) + flex-shrink:0 keeps it at
   full size when the parent collapses — overflow:hidden on .comparison-section
   clips the column instead of display:none, so Plotly always has a valid
   non-zero container. overflow:hidden here clips any child content that
   would otherwise spill past the right edge of the panel. */
.comp-inner {
  width: 318px;   /* 340px panel - 22px tab */
  flex-shrink: 0;
  /* overflow:hidden removed — collapse is clipped by .comparison-section; hidden here was clipping the radar chart */
  display: flex;
  flex-direction: column;
}
.comp-controls { border-bottom: 1px solid #eee; flex-shrink: 0; }
.comp-chart-area { flex: 1; min-height: 0; overflow: visible; }
.comp-chart-area .plotly, .comp-chart-area .html-widget-output { overflow: visible !important; }
/* Collapsed: shrink section to just the tab and clip the inner column */
.comparison-section { overflow: hidden; }
.comparison-section.is-collapsed { width: 22px; }
@media (max-width: 1300px) {
  .comparison-section { width: 280px; }
  .comp-inner { width: 258px; }   /* 280px panel - 22px tab */
}
.comp-controls {
  display: flex;
  flex-direction: column;
  gap: 0.4rem;
  padding: 0.6rem 0.85rem;
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
  color: #222;
}
.comp-hint {
  font-size: 0.73rem;
  color: #222;
  font-style: italic;
  line-height: 1.4;
  margin-top: -0.2rem;
}
.comp-slot { display: flex; align-items: center; gap: 0.5rem; }
.comp-slot .form-group { margin: 0; flex: 1; }
/* Shared actor selectize — comp module + data tabs */
.actor-select { min-width: 0; }
.actor-select .form-group { margin: 0 !important; }
.actor-select .selectize-control { max-width: 100% !important; }
.actor-select .selectize-input {
  font-size: 0.8rem !important;
  font-family: inherit !important;
  color: #333 !important;
  padding: 0.18rem 1.6rem 0.18rem 0.45rem !important;
  min-height: 0 !important;
  border: 1px solid #e0e0e0 !important;
  border-radius: 2px !important;
  box-shadow: none !important;
  line-height: 1.4 !important;
  text-transform: none !important;
  letter-spacing: normal !important;
  font-weight: normal !important;
  display: flex !important;
  align-items: center !important;
  overflow: hidden !important;
}
.actor-select .selectize-input .item {
  color: #333 !important;
  white-space: nowrap !important;
  overflow: hidden !important;
  text-overflow: ellipsis !important;
  flex: 1 !important;
  min-width: 0 !important;
  text-transform: none !important;
  letter-spacing: normal !important;
  font-size: 0.8rem !important;
}
.actor-select .selectize-input input {
  color: #333 !important;
  background: transparent !important;
  font-family: inherit !important;
  font-size: 0.8rem !important;
  flex-shrink: 1 !important;
  min-width: 2px !important;
}
.actor-select .selectize-input input::placeholder { color: #aaa !important; }
.actor-select .selectize-input.focus { border-color: #aaa !important; box-shadow: none !important; }
.actor-select .selectize-dropdown {
  font-size: 0.8rem !important;
  font-family: inherit !important;
  border: 1px solid #ddd !important;
  border-radius: 2px !important;
  box-shadow: 0 2px 6px rgba(0,0,0,0.07) !important;
  text-transform: none !important;
}
.actor-select .selectize-dropdown .option { color: #333 !important; background: #fff !important; }
.actor-select .selectize-dropdown .option.active,
.actor-select .selectize-dropdown .option.selected,
.actor-select .selectize-dropdown .option:hover {
  background: #f4f4f4 !important;
  color: #1a1a2e !important;
}
/* Score readout block shown under each dropdown when actor is selected */
.comp-scores {
  padding: 0.3rem 0.25rem 0.1rem 0.6rem;
  margin-top: -0.25rem;
  border: 2px solid;
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
  color: #222;
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
  color: #222;
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
  flex: 0 0 auto !important;
  align-self: flex-start !important;
  width: 100% !important;
  display: flex !important;
  flex-direction: column !important;
}
.data-tab .card-body {
  overflow: visible !important;
  max-height: none !important;
  height: auto !important;
  flex: 0 0 auto !important;
  display: block !important;
}
/* Stop bslib tab panes at all nesting levels from clipping content */
.data-tab .tab-content,
.data-tab .tab-content > .tab-pane {
  overflow: visible !important;
  height: auto !important;
  max-height: none !important;
}
.tab-content > .tab-pane,
.tab-content > .active {
  overflow: visible !important;
  height: auto !important;
  max-height: none !important;
}
.data-tab .nav-tabs { border-bottom: 2px solid #1a1a2e; margin-bottom: 1.5rem; }
.data-tab .nav-tabs .nav-link {
  color: #222;
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
  color: #1a1a2e !important;
  background: none !important;
  border-color: transparent transparent #1a1a2e !important;
  border-bottom: 3px solid #1a1a2e !important;
}
.data-tab .nav-tabs .nav-link:not(.active) {
  border-color: transparent !important;
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
  color: #222;
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
  color: #222;
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
/* Date column: nowrap, muted */
#gpt_table tbody td:nth-child(2) { white-space: nowrap; font-size: 0.75rem; color: #444; }
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
  letter-spacing: 0.1em; color: #222; margin-bottom: 0.2rem;
}
.stmt-modal-meta {
  font-size: 0.65rem; color: #444; letter-spacing: 0.02em;
  font-weight: normal; margin-bottom: 0.1rem;
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
  letter-spacing: 0.08em; color: #222;
}
.stmt-modal-score-val { font-size: 1rem; font-weight: 600; color: #1a1a2e; }
.stmt-modal-expl-label {
  font-size: 0.65rem; font-weight: 800; text-transform: uppercase;
  letter-spacing: 0.1em; color: #222; margin-bottom: 0.45rem;
}
.stmt-modal-expl { font-size: 0.9rem; line-height: 1.8; color: #444; }
/* Reset button for DT tables */
.dt-reset-btn {
  font-size: 0.72rem;
  padding: 0.18rem 0.55rem;
  border: 1px solid #ccc;
  background: #fff;
  color: #222;
  border-radius: 2px;
  font-family: inherit;
  cursor: pointer;
  display: inline-flex;
  align-items: center;
  gap: 0.25rem;
  line-height: 1.5;
  transition: color 0.12s, border-color 0.12s;
}
.dt-reset-btn:hover { color: #333; border-color: #999; }
/* Download buttons in DT table headers */
.dt-dl-btn {
  font-size: 0.72rem !important;
  padding: 0.18rem 0.55rem !important;
  border: 1px solid #ccc !important;
  background: #fff !important;
  color: #222 !important;
  border-radius: 2px !important;
  font-family: inherit !important;
  cursor: pointer !important;
  display: inline-flex !important;
  align-items: center !important;
  gap: 0.25rem !important;
  line-height: 1.5 !important;
  transition: color 0.12s, border-color 0.12s !important;
  text-decoration: none !important;
  height: auto !important;
}
.dt-dl-btn:hover { color: #333 !important; border-color: #999 !important; }
.dt-dl-btn i, .dt-dl-btn .fa, .dt-dl-btn .glyphicon { display: none !important; }
/* Actor selectize filter in statements header */
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
  color: #444;
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

/* Clickable statement-count cell in actor scores table */
/* Second selector beats the general tr:hover > td { color:#333 !important } rule */
.data-tab table.dataTable tbody td.stmts-link-cell,
.data-tab table.dataTable tbody tr:hover > td.stmts-link-cell {
  cursor: pointer;
  color: var(--bs-link-color) !important;
  text-decoration: underline;
}
/* Light Bootstrap tooltip on that cell */
.stmts-tip .tooltip-inner {
  background: #fff;
  color: #333;
  border: 1px solid #ddd;
  box-shadow: 0 2px 6px rgba(0,0,0,0.09);
  font-size: 0.75rem;
  font-family: Lora, serif;
}
.stmts-tip.bs-tooltip-top    .tooltip-arrow::before { border-top-color:    #ddd; }
.stmts-tip.bs-tooltip-bottom .tooltip-arrow::before { border-bottom-color: #ddd; }
/* Centre the Statements count column in actor table (3rd child = index 2) */
#actor_table thead th:nth-child(3),
#actor_table tbody td:nth-child(3) { text-align: center !important; }

/* Left-align statement text column in statements browser */
#gpt_table tbody td:nth-child(4) { text-align: left !important; }

/* Score columns: horizontally and vertically center the number within the bar */
#actor_table tbody td:nth-child(4),
#actor_table tbody td:nth-child(5),
#actor_table tbody td:nth-child(6),
#gpt_table  tbody td:nth-child(5),
#gpt_table  tbody td:nth-child(6),
#gpt_table  tbody td:nth-child(7) {
  text-align: center !important;
  vertical-align: middle !important;
}

/* All other columns in both tables: vertically centered */
#actor_table tbody td,
#gpt_table   tbody td { vertical-align: middle !important; }

/* visNetwork tooltip: match paper aesthetic */
div.vis-tooltip {
  background: #ffffff !important;
  border: 1px solid #ddd !important;
  border-radius: 3px !important;
  box-shadow: 0 2px 8px rgba(0,0,0,0.10) !important;
  font-family: 'Times New Roman', Times, serif !important;
  font-size: 0.82rem !important;
  color: #222 !important;
  padding: 0.4rem 0.65rem !important;
  max-width: 240px !important;
  line-height: 1.5 !important;
}

/* View-statements link in comp score block */
.comp-stmts-link {
  font-size: 0.68rem;
  color: #222;
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
.comp-stmts-link:hover { color: #000; }

/* Jump-to navigation row */
.section-nav {
  display: flex;
  align-items: center;
  gap: 0.45rem;
  flex-wrap: wrap;
  margin: 0.55rem 0 0;
}
.section-nav-label {
  font-size: 0.82rem;
  color: #222;
  font-style: normal;
  margin-right: 0.1rem;
}
.section-nav-btn {
  font-size: 0.78rem;
  padding: 0.2rem 0.7rem;
  background: #fff;
  border: 1px solid currentColor;
  border-radius: 2px;
  cursor: pointer;
  font-family: inherit;
  transition: opacity 0.12s;
  line-height: 1.5;
}
.section-nav-btn:hover { opacity: 0.7; }
.section-nav-btn.nav-background   { color: #6DB589; }
.section-nav-btn.nav-visions      { color: #5BAAB6; }
.section-nav-btn.nav-findings     { color: #2C3E6B; }
.section-nav-btn.nav-implications { color: #CC8A52; }

"


# ── UI ========================================================================
ui <- page_navbar(
  title = "Negotiating futures",
  theme = bs_theme(
    bootswatch   = "flatly",
    primary      = "#2C3E6B",
    base_font    = "Times New Roman",
    heading_font = "Times New Roman"
  ),
  fillable = FALSE,
  header = tags$head(tags$style(HTML(css))),

  # ── Tab 1: Paper =========================================================
  nav_panel("Paper",

    # Intro text in paper column
    div(class = "paper",
      div(class = "paper-header",
        tags$h1("Negotiating futures: Three visions for the International Seabed Authority"),
        tags$p(class = "subtitle", HTML('Paper by Emil W. Hildebrand and Alice B. M. Vadrot | Published in Geopolitics, 2026 | <a href="http://twinpolitics.eu" target="_blank" style="color:inherit;">ERC TwinPolitics project</a>'))
      ),
      tags$p(HTML(
        'You are looking at the condensed interactive web version of our paper <strong>Negotiating futures: Three visions for the International Seabed Authority</strong>.
        The full published version of it, including references, can be <a href="https://dx.doi.org/10.1080/14650045.2026.2721460" target="_blank">found here</a>.
        Read about the visions by clicking their cards below, use the visualisations to explore our main findings, and visit
        <a href="#" onclick="document.querySelector(\'[data-bs-toggle=tab][data-value=Data]\').click(); return false;">the data tab</a>
        to browse the underlying data. For questions or feedback, please contact <a href="mailto:emil.wieringa.hildebrand@univie.ac.at" style="color:inherit;">Emil W. Hildebrand</a>.'
      )),
      
      div(class = "section-nav",
        tags$span(class = "section-nav-label", "Jump to:"),
        tags$button(class = "section-nav-btn nav-background",   onclick = "scrollToSection('section-background')",   "Introduction"),
        tags$button(class = "section-nav-btn nav-visions",      onclick = "scrollToSection('section-visions')",      "Visions"),
        tags$button(class = "section-nav-btn nav-findings",     onclick = "scrollToSection('section-findings')",     "Main findings"),
        tags$button(class = "section-nav-btn nav-implications", onclick = "scrollToSection('section-implications')", "Implications")
      ),

      tags$hr(class = "sec-divider"),

      tags$h2(id = "section-background", "Introduction"),
      tags$p(
        "States at the ISA may need to critically rethink the very ", HTML("<i>raison d'être</i>"), " of the International Seabed Authority (ISA)."
      ),
      tags$p(
        "The ISA, tasked with governing the international seabed ('the Area')
        'for the benefit of humankind as a whole', has historically operated as a mining
        regulator. But the prospect of deep-sea mining is facing multiple challenges: over
        40 countries, more than 900 scientists, and major global firms have called for a moratorium
        or precautionary pause on deep-sea mining amidst mounting concerns over environmental impacts,
        knowledge gaps, and economic uncertainty."
      ),
      tags$p(
        "We argue that this moment offers an opportunity to imagine ", HTML("<strong>radically different futures</strong>"), " for the ISA as an institution."
      ),
      tags$p(
        "Our contribution in this paper is twofold. First, we construct three visions for the future:
        one favouring the current direction of the ISA and two alternative visions
        asking what the ISA could become if it turned away from deep-sea mining and rebuilt its purpose
        around different parts of its UNCLOS mandate: the ISA as a ", HTML("<strong style='color:#CC8A52;'>Mining Regulator</strong>,"), " a ",
        HTML("<strong style='color:#5BAAB6;'>Marine Scientific Research (MSR) Institution</strong>,"), " and an
        ", HTML("<strong style='color:#6DB589;'>Environmental Custodian</strong>."),""
      ),
      tags$p(
        "Second, we map the discursive seeds of these visions among the state and non-state actors negotiating at the ISA:
        ", HTML("<i>the implicit or explicit ideas about the ISA, its priorities, and its role in governing the Area, as articulated
        by actors in the negotiations, from which alternative futures of the institution may take shape</i>."), " We then place
        each actor in a semantic space between the three visions to explore where the impulses for radically different
        futures may already exist. In addition, we explore factors that may help explain the observed patterns, especially
        keeping in mind the pervasiveness of a North-South divide in global environmental politics and the uneven
        distribution of power in shaping potential futures."
      ),

      tags$hr(class = "sec-divider"),

      tags$h2(id = "section-visions", "Visions"),
      tags$p(
        "To develop each of our three visions, we have used the ISA’s obligations
        of resource development, environmental protection, and MSR as starting points and, with the help
        of discussions in the academic literature, imagined what they would look like if the whole purpose
        of the ISA was rebuilt around each of them. The common heritage principle guides each vision, but its
        operationalisation differs significantly between the three. Each vision is constructed as ideal types,
        allowing us to imagine what the ISA ", HTML("<i>could</i>"), " become."
      ),
      div(class = "visions-grid",
        div(class = "vision-card vision-card-mr",
          onclick = "Shiny.setInputValue('vision_modal_open', 'mr', {priority:'event'})",
          tags$h4("Mining regulator"),
          tags$p(
            "The ISA functions primarily as an industry enabler and regulator, developing and enforcing the
            legal and regulatory framework for deep-sea mining activities. Focus on regulation, resource
            extraction, and facilitating commercial mineral exploitation of the international seabed."
          ),
          tags$p(class = "read-more-hint", "Read more →")
        ),
        div(class = "vision-card vision-card-si",
          onclick = "Shiny.setInputValue('vision_modal_open', 'si', {priority:'event'})",
          tags$h4("MSR institution"),
          tags$p(
            "The ISA serves as a multilateral scientific body that coordinates, promotes, and disseminates
            deep-sea research and science diplomacy. It facilitates international expeditions, operates
            data infrastructure and research platforms, brokers knowledge and technology transfer between
            states, and builds scientific capacity independent of mining activities."
          ),
          tags$p(class = "read-more-hint", "Read more →")
        ),
        div(class = "vision-card vision-card-ec",
          onclick = "Shiny.setInputValue('vision_modal_open', 'ec', {priority:'event'})",
          tags$h4("Environmental custodian"),
          tags$p(
            "The ISA acts as steward and protector of the deep-sea environment, prioritizing conservation
            of seabed biodiversity and ecosystem integrity. Focus on diverse knowledge systems, nature’s
            intrinsic value, and indigenous knowledge. Precautionary measures and preventing harm to marine
            environments for present and future generations guides the ISA’s work."
          ),
          tags$p(class = "read-more-hint", "Read more →")
        )
      ),

      tags$hr(class = "sec-divider"),

      tags$h2(id = "section-findings", "Main findings"),
      tags$p(
        "Using an LLM-based content analysis of a comprehensive statement dataset from the ISA's 30th Session (2025)
        – collected across more than 150 hours of negotiations – we score each actor from 0-1 based on how strongly
        the discursive seeds of each vision appear in their statements."
      ),
      tags$p(HTML(sprintf(
        "Each statement made in a formal setting during the 30th Session of the ISA’s Council and Assembly is included in the analysis.
        After filtering for relevant and substantive statements, a total of <a href=\"#\" onclick=\"event.preventDefault(); gotoStatements()\">%d statements</a> by <a href=\"#\" onclick=\"event.preventDefault(); gotoActorScores()\">%d actors</a> are included.
        Note that this interactive version of the paper uses updated filtering criteria to better account for biases in the LLM model, resulting in a lower number of statements than in the original published paper. The overall findings remain robust.",
        nrow(gpt_results), nrow(dta_agg)
      ))),
      tags$hr(class = "sec-divider"),
      div(class = "finding",
        tags$h3("Finding 1: Distribution of discursive seeds among actors"),
        tags$p(
          "Below is a network mapping state and non-state actors at the ISA negotiations in a semantic space between our three visions
          based on their average score across all statements.
          Hover over an actor to see their scores, or click two actors to compare their score profile in the actor comparison module.
          Filter actor types and clusters by clicking their labels in the legend. A 3D version of the semantic space is also available
          by clicking the top right button."
        ),
        tags$p("Please note that, while the overall patterns are robust, caution should be used when interpreting the exact position of specific actors. Especially for actors delivering only a few or very short statements, small differences in the model's interpretation may lead to some variations in the exact vision scores."),
      ),
    ),

    # Combined network / 3D view
    div(class = "network-section",
      div(class = "net-canvas-box",

        # Plot area
        div(class = "net-plot-area",
          div(class = "view-btn-group",
            tags$button(id = "reset-view-btn",  class = "reset-view-btn",  title = "Reset view", bs_icon("aspect-ratio")),
            tags$button(id = "view-toggle-btn", class = "view-toggle-btn", title = "Switch view", "Switch to 3D")
          ),
          div(id = "net-plot-wrap",
            withSpinner(visNetworkOutput("network_plot", height = "600px"), type = 7, color = "#1a1a2e")
          ),
          div(id = "sc3-plot-wrap", style = "display:none;",
            withSpinner(plotlyOutput("scatter3d_plot", height = "600px"), type = 7, color = "#1a1a2e")
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
          div(class = "legend-item", id = "legend-cl-3",
            onclick = "toggleLegend('cluster','3',this)",
            tags$span(class = "lgd-sw lgd-circle", style = "background:#6DB589;"),
            tags$span("Env. cust. + MSR inst.")
          ),
          div(class = "legend-item", id = "legend-cl-4",
            onclick = "toggleLegend('cluster','4',this)",
            tags$span(class = "lgd-sw lgd-circle", style = "background:#5BAAB6;"),
            tags$span("Env. cust. + Mining reg.")
          ),
          div(class = "legend-item", id = "legend-cl-2",
            onclick = "toggleLegend('cluster','2',this)",
            tags$span(class = "lgd-sw lgd-circle", style = "background:#8A7ABF;"),
            tags$span("Mining reg. + Env. cust.")
          ),
          div(class = "legend-item", id = "legend-cl-1",
            onclick = "toggleLegend('cluster','1',this)",
            tags$span(class = "lgd-sw lgd-circle", style = "background:#CC8A52;"),
            tags$span("Mining regulator")
          ),

          # Actor type section
          div(class = "lgd-sep"),
          div(class = "legend-section-label", "Actor type"),
          div(class = "legend-item", id = "legend-type-ms",
            onclick = "toggleLegend('type','member_state',this)",
            tags$span(class = "lgd-sw lgd-circle", style = "background:#999;"),
            tags$span("Member State")
          ),
          div(class = "legend-item", id = "legend-type-rg",
            onclick = "toggleLegend('type','regional_group',this)",
            tags$span(class = "lgd-sw lgd-hexagon", style = "background:#999;"),
            tags$span("Regional Group")
          ),
          div(class = "legend-item", id = "legend-type-ngo",
            onclick = "toggleLegend('type','observer_ngo',this)",
            tags$span(class = "lgd-sw lgd-square", style = "background:#999;"),
            tags$span("Observer NGO")
          ),
          div(class = "legend-item", id = "legend-type-igo",
            onclick = "toggleLegend('type','observer_igo',this)",
            tags$span(class = "lgd-tri", style = "border-bottom: 9px solid #999;"),
            tags$span("Observer IGO")
          ),
          div(class = "legend-item", id = "legend-type-isa",
            onclick = "toggleLegend('type','isa',this)",
            tags$span(class = "lgd-sw lgd-diamond", style = "background:#999;"),
            tags$span("ISA")
          ),
          div(class = "legend-item", id = "legend-type-obs",
            onclick = "toggleLegend('type','observer_state',this)",
            tags$span(class = "lgd-tri", style = "border-top: 9px solid #999;"),
            tags$span("Observer State")
          ),

          # Reset button
          tags$button(class = "reset-filter-btn", onclick = "resetFilters()",
            HTML("&#8635;"), "Reset filters"
          )
        )
      ),

      # ── Actor comparison (right column on wide screens, below on narrow)
      div(class = "comparison-section",

        # Collapse/expand tab — always visible on the inner edge of the panel
        div(class = "comp-collapse-tab", id = "comp-collapse-tab",
          title = "Collapse comparison panel",
          tags$span(class = "comp-tab-icon comp-tab-collapse", bs_icon("chevron-right")),
          tags$span(class = "comp-tab-icon comp-tab-expand",   bs_icon("chevron-left"))
        ),

        # Inner column: controls + chart (hidden when collapsed)
        div(class = "comp-inner",
        div(class = "comp-controls",
          div(class = "comp-section-label", "Actor Comparison"),
          div(class = "comp-hint", "Click actors in the graph, or choose below"),
          div(class = "comp-slot",
            uiOutput("badge_a"),
            div(class = "actor-select", style = "flex:1;",
              selectizeInput(
                "comp_actor_a", NULL,
                choices  = actor_choices,
                selected = "",
                width    = "100%",
                options  = list(placeholder = "Select actor")
              )
            )
          ),
          uiOutput("comp_scores_a"),
          div(class = "comp-slot",
            uiOutput("badge_b"),
            div(class = "actor-select", style = "flex:1;",
              selectizeInput(
                "comp_actor_b", NULL,
                choices  = actor_choices,
                selected = "",
                width    = "100%",
                options  = list(placeholder = "Select actor")
              )
            )
          ),
          uiOutput("comp_scores_b")
        ),

        # Chart
        div(class = "comp-chart-area",
          withSpinner(plotlyOutput("comp_plot_combined", height = "290px"), type = 7, color = "#1a1a2e")
        )
        ) # end comp-inner
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

      function gotoActorScores() {
        var dataTab = document.querySelector('[data-bs-toggle=\"tab\"][data-value=\"Data\"]');
        if (dataTab) dataTab.click();
        setTimeout(function() {
          var sub = document.querySelector('[data-bs-toggle=\"tab\"][data-value=\"Actor Scores\"]');
          if (sub) sub.click();
        }, 200);
      }
      function gotoStatements() {
        var dataTab = document.querySelector('[data-bs-toggle=\"tab\"][data-value=\"Data\"]');
        if (dataTab) dataTab.click();
        setTimeout(function() {
          var sub = document.querySelector('[data-bs-toggle=\"tab\"][data-value=\"Statements\"]');
          if (sub) sub.click();
        }, 200);
      }

      function scrollToSection(id) {
        var el = document.getElementById(id);
        if (!el) return;
        var navbar = document.querySelector('.navbar');
        var offset = navbar ? navbar.offsetHeight + 20 : 80;
        window.scrollTo({top: el.getBoundingClientRect().top + window.pageYOffset - offset, behavior: 'smooth'});
      }
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
        var btn    = document.getElementById('view-toggle-btn');
        var rstBtn = document.getElementById('reset-view-btn');
        var net    = document.getElementById('net-plot-wrap');
        var sc3    = document.getElementById('sc3-plot-wrap');
        if (!btn) return;

        // Reset view buttons
        rstBtn.addEventListener('click', function() {
          var plotEl = document.getElementById('scatter3d_plot');
          if (plotEl && window.Plotly) {
            Plotly.relayout(plotEl, {'scene.camera': {eye: {x:1.5, y:1.5, z:0.8}}});
          }
          Shiny.setInputValue('reset_view', Math.random(), {priority: 'event'});
        });

        var PLOT_RATIO    = 0.70;
        var lastPlotWidth = 0;

        // Get the vis.js Network instance (null if not ready)
        function getVisNetwork() {
          var w = window.HTMLWidgets && HTMLWidgets.find && HTMLWidgets.find('#network_plot');
          return (w && w.instance && w.instance.network) ? w.instance.network : null;
        }

        // Resize plots to height h and restore vis.js view position after resize.
        // Hooks into vis.js 'resize' event so moveTo fires at full canvas resolution.
        function setPlotHeights(h) {
          var visNet = getVisNetwork();
          var savedScale = null, savedPos = null;
          if (visNet) {
            savedScale = visNet.getScale();
            savedPos   = visNet.getViewPosition();
            var moved = false;
            var restoreView = function() {
              if (moved) return;
              moved = true;
              visNet.off('resize', restoreView);
              visNet.moveTo({ position: savedPos, scale: savedScale, animation: false });
            };
            visNet.on('resize', restoreView);
            setTimeout(restoreView, 300); // fallback
          }
          var netDiv = document.getElementById('network_plot');
          if (netDiv) netDiv.style.height = h;
          var sc3Div = document.getElementById('scatter3d_plot');
          if (sc3Div) {
            sc3Div.style.height = h;
            if (window.Plotly) Plotly.Plots.resize(sc3Div);
          }
        }

        // Recalculate height from plot-area width; skip if width unchanged.
        function updateNetworkHeight() {
          var plotArea = document.querySelector('.net-plot-area');
          if (!plotArea) return;
          var w = plotArea.clientWidth;
          if (w <= 0 || w === lastPlotWidth) return;
          lastPlotWidth = w;
          var byWidth = Math.round(w * PLOT_RATIO);
          var byVP    = Math.round(window.innerHeight * 0.72);
          var h = Math.max(320, Math.min(byWidth, byVP));

          // Floor on network height: the comparison panel's natural content height
          // (controls + fixed 400px chart). Without this, a width-based h smaller than
          // the panel leaves blank space at the bottom of the module box.
          var compSection = document.querySelector('.comparison-section');
          if (compSection && !compSection.classList.contains('is-collapsed')) {
            var ctrl    = compSection.querySelector('.comp-controls');
            var chartEl = document.getElementById('comp_plot_combined');
            var ctrlH   = (ctrl    && ctrl.offsetHeight)    ? ctrl.offsetHeight    : 320;
            var chartH  = (chartEl && chartEl.offsetHeight) ? chartEl.offsetHeight : 300;
            var cs      = window.getComputedStyle(plotArea);
            var padV    = parseFloat(cs.paddingTop  || 0) +
                          parseFloat(cs.paddingBottom || 0);
            h = Math.max(h, ctrlH + chartH - padV);
          }

          setPlotHeights(h + 'px');
        }

        // Debounced window resize
        var resizeTimer;
        window.addEventListener('resize', function() {
          clearTimeout(resizeTimer);
          resizeTimer = setTimeout(updateNetworkHeight, 100);
        });

        // Compare panel collapse tab
        var compTab     = document.getElementById('comp-collapse-tab');
        var compSection = document.querySelector('.comparison-section');
        if (compTab && compSection) {
          compTab.addEventListener('click', function() {
            compSection.classList.toggle('is-collapsed');
            compTab.title = compSection.classList.contains('is-collapsed')
              ? 'Expand comparison panel'
              : 'Collapse comparison panel';
            lastPlotWidth = 0; // force width recalculation after layout reflow
            setTimeout(updateNetworkHeight, 50);
          });
        }

        // View switch (Network / 3D)
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

        setTimeout(updateNetworkHeight, 300);

        // Poll until vis.js Network instance is available (typically 8-10s on first load).
        // Once found, force a height recalculation and also bind to 'stabilized' as a
        // second pass in case node layout shifts the canvas size after initialization.
        var networkReadyPoller = setInterval(function() {
          var visNet = getVisNetwork();
          if (!visNet) return;
          clearInterval(networkReadyPoller);
          lastPlotWidth = 0;
          updateNetworkHeight();
          visNet.once('stabilized', function() {
            lastPlotWidth = 0;
            updateNetworkHeight();
          });
        }, 400);
        // Safety: stop polling after 60 seconds regardless.
        setTimeout(function() { clearInterval(networkReadyPoller); }, 60000);

        // Watch the whole comparison section so any child rendering (scores, chart)
        // triggers a floor recalculation.
        var compSectionEl = document.querySelector('.comparison-section');
        if (compSectionEl && window.ResizeObserver) {
          new ResizeObserver(function() {
            lastPlotWidth = 0;
            updateNetworkHeight();
          }).observe(compSectionEl);
        }

        // Resize the comp radar chart after each Shiny render so Plotly measures
        // the flex container AFTER layout has settled (avoids the default-width ghost render).
        $(document).on('shiny:value', function(e) {
          if (e.name === 'comp_plot_combined') {
            setTimeout(function() {
              var el = document.getElementById('comp_plot_combined');
              if (el && window.Plotly) Plotly.Plots.resize(el);
            }, 50);
          }
        });

      });
    ")),

    # Findings in paper column
    div(class = "paper paper-last",
      tags$hr(class = "sec-divider"),

      # Finding 2: dev status bars below text, interactive leaflet map
      div(class = "finding",
        tags$h3("Finding 2: Geographic differences and development status do not explain vision scores"),
        
        div(class = "finding-map-container",
            div(class = "map-toggle",
                div(style = "display:flex; align-items:center;",
                    radioButtons("map_vision", NULL,
                                 choices  = c("Mining reg." = "mr",
                                              "MSR institution" = "si",
                                              "Env. custodian"  = "ec"),
                                 selected = "mr", inline = TRUE
                    ),
                    tags$button(
                      class   = "reset-view-btn",
                      title   = "Reset map view",
                      style   = "margin-bottom: 0.6rem; margin-left: 0.6rem; flex-shrink: 0;",
                      onclick = "Shiny.setInputValue('reset_map_view', Math.random(), {priority:'event'})",
                      bs_icon("aspect-ratio")
                    )
                )
            ),
            leafletOutput("finding1_map", height = "580px")
        ),
        
        tags$p(
          "Contrary to what one might expect, geographical region or development status do not seem to explain
          differences in vision invocation between state actors. This finding is particularly interesting
          within the context of global environmental negotiations, where recurrent patterns of unbalanced
          developed-developing relations contribute to the disproportionate control by developed countries over
          negotiation forums, agendas, and decisions, and the marginalization of developing state perspectives.
          The ISA was conceived with the goal of facilitating access of developing states to the Area and its resources.
          The lack of systematic differences between regions and economic development status may in part
          reflect this promise to safeguards the interests of developing states.",
          
          style = "margin-top: 2rem;"
        ),
        tags$p(
          "The question of power is central when considering alternative futures and future change: some actors have more power, economic or otherwise,
          to imagine their visions of the future into being. In our case, there seems to be no clear correlation between invoked
          future visions and traditional power structures – as indicated here by geography and development status.
          This suggests that, at least at the discursive level, the future of the ISA may be less pre-determined by the power imbalances
          that shape other multilateral environmental forums."
        ),
        
        div(class = "finding-chart-wrap", withSpinner(plotlyOutput("finding1_bars", height = "500px"), type = 7, color = "#1a1a2e"))
      ),

      tags$hr(class = "sec-divider"),

      # Finding 3: mora/sponsor + SIDS in equal grid below text
      div(class = "finding",
        tags$h3("Finding 3: States with vested interests in deep-sea mining are less likely to invoke environmental or MSR visions"),
        tags$p(
          "Deep-sea mining is a brand-new (potential) industry and remains highly speculative. There may be less long-term entrenched
          national interests and predictable geopolitical dynamics in deep-sea mining than in other industries. Thus, we find more
          explanatory power in sponsorship status and moratorium stance – the former serving as a signal that a state has ‘bought into’
          and invested in the idea of deep-sea mining as a profitable endeavour and the latter signalling a degree of doubt towards the
          (current) economic or environmental sustainability of it."
        ),
        div(class = "finding-chart-wrap", withSpinner(plotlyOutput("finding2_mora_bars", height = "500px"), type = 7, color = "#1a1a2e")),
        tags$p(
          "A stark example of this can be found within the SIDS group, where some states count among the most ardent opponents of
          deep-sea mining (for example Palau, Samoa, Tuvalu), whereas others sponsor exploration contracts
          (for example Cook Islands, Nauru, Tonga). Some actors have also qualified their position towards deep-sea mining in recent
          years, such as Germany, the sponsor of two exploration contracts, calling for a precautionary pause and urging other
          states to do the same. In such a context, where vested interests are in flux, the ideational abilities of actors
          may carry particular weight in determining the ISA's future."
        ),
        div(class = "finding-chart-wrap", withSpinner(plotlyOutput("finding2_sids_bars", height = "500px"), type = 7, color = "#1a1a2e"))
      ),

      tags$hr(class = "sec-divider"),

      # Finding 4: ISA secretariat vs member states
      div(class = "finding",
        tags$h3("Finding 4: The ISA secretariat differs substantially from the member states it represents"),
        tags$p(
          "While the discursive seeds of diverse potential futures exist within the negotiation space, they are unevenly distributed
          between different components of the ISA as an institution. We observe a stronger invocation of the mining regulator vision
          from the ISA’ Secretary General than among its negotiating member states and non-state observers. The opposite is true for
          the environmental custodian vision. In other words, there are differences between the ISA as a bureaucracy and the ISA as a
          multilateral forum."
        ),
        div(class = "finding-chart-wrap", withSpinner(plotlyOutput("finding3_bars", height = "500px"), type = 7, color = "#1a1a2e")),
        tags$p(
          "If the ISA’s secretariat is to represent its member states evenly and manage the Area on behalf of its
          negotiating parties, our findings suggest a necessary shift towards a stronger environmental custodian role.
          This becomes even clearer when looking at differences between the ISA secretariat and the civil society actors engaged in
          the negotiations. The ISA is, after all, dependent not only on political will but also social legitimacy."
        )
      ),

      tags$hr(class = "sec-divider"),

      tags$h2(id = "section-implications", "Implications"),
      
      tags$p("On a broader level, we raise the question of whether the ISA can move beyond its mining regulator orientation.
             From the perspective of discursive institutionalism, actors can persuade other actors to adopt alternative views,
             creating opportunities to reorient the ISA towards MSR and environmental custodianship as other legitimate
             operationalisations of the common heritage principle – not to mention the myriad of other possible visions for
             the ISA that we have not engaged with here. Such change requires actors within the ISA negotiations to openly
             discuss alternative visions for the future. While there are examples of explicit imaginations of alternative
             futures within the negotiations – France, for example, wishing to make ‘Kingston and the Authority
             the beating heart of oceanic science on the deep seabed’ – most visions remain implicit."),
      
      tags$p("The ISA indeed has an arena where such discussions should be possible: The Assembly has an explicit mandate to
             discuss overarching policies for the ISA and to initiate a periodic review every five years –
             both of which would provide room for actors to actively and explicitly discuss their visions for the ISA.
             The insistent focus on the Mining Code and its use as a reason for deferring processes also in Assembly, however,
             marginalises explicit discussions on alternative futures. This inherently favours a status quo-oriented path forward."),
      
      tags$p("The ISA and its member states may do well in remembering the ‘potentiality in a regime that continues to be in the making”.
        Deep-sea mining remains, after all, a potential industry and its commencement is not inevitable.
        Thus, the future of the ISA is not fixed to one path but remains dependent on the political will of the actors negotiating
        its role and their visions for its future."),
    
      tags$p("Time will tell whether the alternative visions imagined in this paper – or completely new ones – come to pass in some form or another.
        Ultimately, the legitimacy of the ISA does not rest on its capacity to initiate mineral exploitation, but on its ability to govern
        the Area in a way that reflects the common heritage principle. As the ISA enters its fourth decade of operations and under new
        leadership, the organisation and its member states may take this critical moment to explicitly reflect on the ISA’s role as a steward
        of the common heritage of humankind and its way forward."),
    )
  ),

  # ── Tab 3: Data =============================================================
  nav_panel("Data",
    div(class = "data-tab",
      navset_tab(

        nav_panel("Actor Scores",
          br(),
          card(fill = FALSE,
            card_header(
              span("Mean vision scores per actor"),
              div(class = "dt-hdr-ctrl",
                div(class = "actor-select", style = "width:200px;",
                  selectizeInput("actor_table_actor", NULL,
                    choices  = actor_choices,
                    selected = "", width = "100%",
                    options  = list(placeholder = "Select actor")
                  )
                ),
                tags$button(
                  class   = "dt-reset-btn",
                  onclick = "$('#actor_table_actor')[0].selectize.setValue('');",
                  bs_icon("arrow-counterclockwise"), "Reset"
                ),
                downloadButton("dl_actor_csv",   "Download CSV",   class = "dt-dl-btn", style = "margin-left:0.75rem;"),
                downloadButton("dl_actor_excel", "Download Excel", class = "dt-dl-btn")
              )
            ),
            DTOutput("actor_table")
          )
        ),

        nav_panel("Statements",
          br(),
          card(fill = FALSE,
            card_header(
              span("Click any row to view the full text and model explanation"),
              div(class = "dt-hdr-ctrl",
                div(id = "gpt-hdr-ctrl"),
                div(class = "actor-select", style = "width:200px;",
                  selectizeInput("gpt_actor", NULL,
                    choices  = actor_choices,
                    selected = "", width = "100%",
                    options  = list(placeholder = "Select actor")
                  )
                ),
                tags$button(
                  class   = "dt-reset-btn",
                  onclick = "$('#gpt_table table').DataTable().search('').draw(); $('#gpt_actor')[0].selectize.setValue('');",
                  bs_icon("arrow-counterclockwise"), "Reset"
                ),
                downloadButton("dl_stmt_csv",   "Download CSV",   class = "dt-dl-btn", style = "margin-left:0.75rem;"),
                downloadButton("dl_stmt_excel", "Download Excel", class = "dt-dl-btn")
              )
            ),
            DTOutput("gpt_table")
          )
        )
      )
    )
  ),
  
  # ── Tab 2: Documentation ====================================================
  nav_panel("Documentation",

    div(class = "paper",

      div(class = "paper-header",
        tags$h1("Documentation")
      ),

      tags$h2("Notes"),
      
      tags$p(HTML("This interactive version of our paper is a condensed version of the original published version, which can be <a href=\"https://dx.doi.org/10.1080/14650045.2026.2721460\" target=\"_blank\">found here</a>. The data, methods, and analysis are identical to the original, with the exception of a stricter filtering applied to the statements resulting in a lower number of statements (362 instead of 505) and actors (91 instead of 97). The patterns and findings remain robust.")),
      
      tags$p(HTML("This paper is part of the <a href=\"https://twinpolitics.eu\" target=\"_blank\">TwinPolitics project</a> at the University of Vienna, led by Prof. Alice Vadrot and funded by the European Research Council (grant No 101124903 – TwinPolitics – ERC-2023-CoG). The interactive version is an R shiny application built on the original paper code and developed into a working web version with the help of Claude Code. The full code for the interactive version can be <a href=\"https://github.com/ehildeb/futures_interactive\" target=\"_blank\">found here</a>.")),

      tags$hr(class = "sec-divider"),

      tags$h2("Method"),
      
      tags$p("Please refer to the published version for the full overview of the method."),

      tags$h3("Data collection and processing"),

      tags$p("The statement data used in this analysis was collected using Collaborative Event Ethnography and covers a full year of ISA negotiations, online and on-site in Kingston, including the Council meeting in Part I of the ISA’s 30th Session from March 17-28, 2025, and the Council and Assembly meetings in Part II of the 30th Session from July 7-25, 2025. A transcript of every statement made during the negotiations was collected in a database together with the actor, time and date, negotiation setting (informal or formal), as well as personal notes from the researcher. The statements were automatically transcribed from the ISA’s publicly available livestream."),

      tags$p("Only statements made in a formal negotiation setting are included in the analysis. The data was further filtered to only include statements made by states, NGOs, IGOs, and ISA representatives. After filtering for statements of a substantive nature (i.e. discarding statements marked as purely procedural during the analysis), the final sample contains 362 statements across 91 actors."),

      tags$h3("Analysing negotiation data using an LLM approach"),

      tags$p("Our analysis consists of scoring every negotiation statement on a 0-1 scale indicating how strongly it contains discursive seeds of the three visions, using the large language model GPT-5 Mini."),

      tags$h4("Prompt building and validation"),

      tags$p("The ‘black-box’ nature of LLMs makes evaluation and prompt validation a crucial task. In line with academic best practices, the model prompt was constructed, evaluated, and reconstructed in an iterative process to ensure validity and consistency following a five-step approach. The final prompt can be found in Appendix C of the published paper."),

      tags$h4("Model limitations and robustness checks"),

      tags$p("A limitation of the model is that it functions best with longer statements, such as general opening statements where countries present their broad positions. For shorter statements, the model sometimes looks for evidence where a human coder might question its inclusion for lack of substantive amounts of text. This was particularly the case for shorter statements addressing practical or regulatory matters. The model tends to score these statements higher on the mining regulator vision, leading to an inflation of this score for certain particularly active actors. In a traditional research design, such statements would likely be marked by the coder and discussed within the research team. This lack of flagging and discussion must be acknowledged as a weakness of using an LLM-based approach compared to human coders."),

      tags$p("To validate the model’s understanding of the three visions and the 0-1 scale, it was asked to provide its own explanation based on the original prompt. The explanation is consistent with the understanding of the researchers (see Appendices D and E in the published paper). A stochasticity test shows an average standard deviation of 0.319 across five separate runs of the analysis. On a 0-1 scale this is high. An intraclass correlation coefficient test (ICC), however, reveals that the relative scoring of each statement is highly consistent across runs (two-way mixed effects model, ‘consistency’ definition, ICC > 0.9 for all three visions = ‘excellent reliability’). In other words, any observed patterns between actors remain highly robust across multiple runs."),

      tags$h4("LLM bias and model choice"),

      tags$p("The model does not solely rely on the system prompt when analysing each statement. Like a human coder, it brings with it an existing ‘understanding’ of the ISA and deep-sea mining, in this case based on the model’s training data. The model seems to harbour some bias towards the ISA as a mining regulator. The bias became clear in the model's scoring of statements on the mining regulator vision based on certain words such as ‘activities’, ‘common heritage’, ‘benefit-sharing’, and ‘capacity building’, even when it was not immediately clear whether the actor was referring to mining or mining regulation. For the sake of validity, the model was instructed to read such terms in context and only score them when it was clear what sort of vision they invoked. Despite this, the model sometimes gave scores based on these terms even when their context was not explicitly mentioned."),

      tags$p("It is generally considered best practice to use open-source models when conducting an LLM-based analyses. Our choice of OpenAI’s GPT-5 Mini, however, is motivated by its sophistication and large knowledge base. Given the high specificity of the negotiations and the multilateral setting in which the statements are made, the model must be able to handle highly specialised content. By conducting robustness, bias, and stochasticity tests as outlined above, following a rigorous prompt validation process, and being transparent about the prompt and model parameters used (Appendices A-D), we have sought to minimise potential issues of using a commercial model."),

      tags$h3("Computing and interpreting final scores"),

      tags$p("Final scores were computed by taking the average of the statements from each actor for each vision. The scores are independent of each other, meaning that an actor can score high on all three visions, low on all three, or a mix. To prevent statements that did not address a vision at all from artificially pulling the averages down, zero-values were excluded when calculating the means. The African countries, who usually speak as one group, are assigned the mean score of the group. For those African countries that in addition chose to deliver statements unilaterally, their final score is the combined mean of their own and that of the group."),

      tags$p("The final scores represent how strongly discursive seeds of the three visions appear in an actor’s statements on average throughout the negotiations. The scores do not mean that an actor explicitly supports any vision in their statement, neither should the scores be read as direct proxies for an actor’s stance on deep-sea mining. This particularly applies to the mining regulator vision, as actors may favour both lenient and strict regulations and still score high on the regulator vision. The scores do indicate, however, when an actor expresses ideas that correspond with such understandings of the role of the ISA or its future."),

      tags$p("Finally, our data covers one year of negotiations, with its specific agenda points and topics. Different agenda points may have brought different emphases and topics. However, all actors have the same opportunity to speak on the same agenda points, meaning that we can meaningfully analyse the relative differences between the actors in our data."),

    )
  ),
  
)


# ── Server ====================================================================
server <- function(input, output, session) {

  # Vision card modals ----------------------------------------------------------
  vision_content <- list(

    mr = list(
      title = "The ISA as a Mining Regulator",
      body  = tagList(
        tags$p("UNCLOS and the 1994 Agreement established the ISA to develop the mineral resources in the Area for the benefit of humankind. This orientation has so far shaped the ISA's work, with the development of regulatory frameworks for mineral exploration and exploitation as its primary focus."),
        tags$p("The Mining Code, comprising regulations, standards and guidelines for deep-sea mining, forms the core of the mining regulator vision. The Mining Code is what will enable commercial mining of the deep sea, but also what will determine its guardrails, including environmental protection, scientific data and monitoring regulations, and equity provision to ensure the participation of developing states. Despite intense negotiations following Nauru's 2021 triggering of the 'two-year rule', a provision of the 1994 Agreement compelling the ISA to finish its deliberations within two years, and missed deadlines in both 2023 and 2025, the Mining Code remains unfinished. The ISA Council is now pursuing a 'thematic approach' to completing the Mining Code, without a fixed deadline."),
        tags$p("Finishing the Mining Code is not the only outstanding step in realising the ISA as a mining regulator. The ISA's 'evolutionary approach' of implementation envisions additional elements: establishing a benefit-sharing mechanism, operationalising the Enterprise, and constituting the Economic Planning Commission. These components are essential not only to establishing a functioning regulatory regime, but to ensuring that the ISA heeds its equity obligations under the common heritage principle."),
        tags$p("Establishing a benefit-sharing mechanism is central to operationalising the CHP by distributing the profits derived from commercial deep-sea mining among member states. Two broad approaches have been discussed so far: direct distribution or a 'Common Heritage Fund', but neither has received substantive discussion in Council or Assembly. The Enterprise, originally conceived as the ISA's operational arm for mining, transportation, and refinement of minerals to ensure the effective participation of developing states, so far only exists on paper, employing an interim director-general and a research assistant. Some discussion exists as to whether the Enterprise must be operational before deep-sea mining may take place, but as a direct vehicle for developing states to participate in the activities in the Area, it remains a central pillar of the mining regulator vision. Similarly, the EPC was established to avoid adverse economic impacts on developing mineral-producing states from deep-sea mining. Having only been established in 2025, its operationalisation remains an important step towards the mining regulator vision. Operationalising a benefit-sharing mechanism, the Enterprise, and the EPC will set up the structures through which the ISA can function as a mining regulator in line with the CHP."),
        tags$p("In the mining regulator vision, deep-sea mining and its regulation sits at the centre of the ISA's work, and other obligations are defined in relation to it. Science serves primarily to establish baselines, assess potential negative impacts, and inform contractor obligations. Environmental measures exist to ensure that mining proceeds sustainably as possible."),
        tags$p("This path forward assumes that deep-sea mining is inevitable, and positions the ISA as the institution that makes it possible under international law. The ISA's legitimacy derives from its capacity to facilitate access to seabed minerals while preventing a 'free-for-all' among technologically and economically advantaged nations, implementing the CHP through regulated commercial exploitation.")
      )
    ),

    si = list(
      title = "The ISA as a Marine Scientific Research Institution",
      body  = tagList(
        tags$p("The deep sea is by far the biggest ecosystem on Earth and the most understudied. MSR in the Area has drastically increased in recent years, and the ISA has made efforts to expand its scientific activities. However, despite arguments that the ISA's MSR obligation is separate from that of mineral development, these efforts have to a large extent been tied to mining-related activities (critical or not). By and large, the ISA's scientific initiatives focus on the potential impacts of deep-sea mining, collection of baseline data within contract areas, and informing environmental impact assessments. The DeepData database, the ISA's flagship deep-sea data initiative, consists mostly of data supplied by mining contractors."),
        tags$p("Many conditions are already in place that would enable the ISA to transform into a marine scientific research institution proper. As an institution with experience in coordinating multilateral action across both public and private sectors, the ISA can be imagined as a coordinator of multi-state scientific missions. ISA-led scientific efforts could have a strong focus on equity and capacity-building, enabling access for developing states to research vessels, technologies, scientific training, and areas that are otherwise inaccessible. Amon, Levin, et al. highlight the possibility of refitting the not-yet-operationalised Enterprise from a mining organ to an MSR vehicle, operating a fleet of research vessels and deep-sea submersibles accessible to all member states."),
        tags$p("Much of the infrastructure currently connected to mining-related activities can be shifted towards conducting independent research independent from mining activities. The DeepData database could become a leading data repository for deep-sea data. Moving away from contractor-based inputs would not only avoid questions about data quality and independence, but also allow the inclusion of geological and bathymetric data that have so far been kept confidential for commercial reasons. Highly advanced monitoring systems such as the EU-funded TRIDENT project currently under development provide large-scale platforms already fit for a deep-sea environment, potentially able to be directed away from monitoring mining operations and towards broader scientific purposes."),
        tags$p("An ISA dedicated to coordinating MSR could drive technological innovation and scientific advances through 'mutual learning' and 'technology co-development'. This would benefit both developing and developed countries by expanding access to intellectual capital, skilled workers, and knowledge exchange, and potentially positioning 'developing states as global leaders in high-value sectors of the knowledge economy at the forefront of future opportunities'. An MSR-oriented ISA could enable developing states to take a larger part in bioprospecting and the use of marine genetic resources in conjunction with the BBNJ Agreement."),
        tags$p("As an MSR institution, the ISA could figure as a deep-sea institutional node within an expanding network of scientific institutions and collaborative efforts to foster ocean science and data diplomacy across relevant international organisations, including the BBNJ Agreement, the IMO, IOC-UNESCO, ICES, the CBD, the FAO and RFMOS.")
      )
    ),

    ec = list(
      title = "The ISA as an Environmental Custodian",
      body  = tagList(
        tags$p("As the sole body governing the mineral resources of the Area, the ISA is also the institution mandated to manage non-use of these resources. An agreement among member states either in Council or Assembly to impose a moratorium or ban on mining in the Area, together with a general environmental policy for the ISA, could provide a strong basis for transforming the ISA into an environmental custodian."),
        tags$p("So far, the ISA has established non-use measures in the form of Areas of Particular Environmental Interest (APEIs), in the Clarion Clipperton Zone, where no mining is allowed but MSR activities may be carried out. While these APEIs represent important first steps towards fulfilling the environmental obligations of the ISA, their size and placement may not adequately protect deep-sea environments. Other area-based management tools of the ISA, such as impact and preservation reference zones remain tied to specific mining contractor areas, functioning as exploitation guardrails rather than preservation measures in their own right."),
        tags$p("The ISA could establish extensive marine protected areas and biodiversity conservation corridors across the international seabed. These areas would be designed to monitor and preserve deep-sea ecosystems and vulnerable habitats, informed by understandings of ecological connectivity, evolutionary processes, and climate resilience. Ecosystem restoration represents another concrete function for the ISA as a custodian. While restoration of deep-sea environments is challenging, the ISA could coordinate research into restoration techniques for mitigating human impacts such as historical mining tests, bottom trawling and, more broadly, impacts of climate change."),
        tags$p("Central to the custodian vision is recognizing and operationalizing diverse values of the deep sea beyond mineral resources or quantifiable ecosystem services. The IPBES Values Assessment framework acknowledges that nature holds intrinsic value independent of human use, alongside relational values rooted in cultural connections and responsibilities. For the ISA, this means incorporating Indigenous and local knowledge systems, traditional relationships with the ocean, and non-Western ontologies that recognize the deep sea as a rights-bearing entity. One proposal consists of establishing a '37th seat' for the deep sea in Council, granting 'legal guardians or proxies the power to speak for deep-sea ecosystems'."),
        tags$p("Operationalizing these values requires transforming governance structures. The ISA could establish dedicated mechanisms for Indigenous Peoples and local communities to participate meaningfully in decision-making, bringing traditional knowledge and alternative governance models into managing the Area. This can include representation on subsidiary bodies, recognition of existing ocean stewardship practices, and incorporating different value frameworks into area-based management decisions."),
        tags$p("Similarly, the election rules for Council membership can be reimagined. Seats in Council are distributed among five groups of states representing mineral consumers, deep-sea mining investors, mineral exporters, developing states, and one group to ensure geographical distribution of members – an approach that 'treats the configuration of interests' in deep-sea mining as 'largely fixed' and favouring the mining-focused priorities of 1994. No special group is dedicated to potentially affected coastal states, states whose cultural or economic traditions rely on the deep sea, or states investing in MSR."),
        tags$p("From an economic perspective, the custodian vision aligns with growing evidence that preserving the deep sea may generate greater value for humankind than extracting its minerals. The ISA as a custodian would actively maintain this natural capital; the deep sea's contributions to climate regulation, nutrient cycling, carbon sequestration, and genetic diversity that provide benefits in both economic and non-economic terms."),
        tags$p("Institutional reform could see the ISA establishing a new environmental subsidiary body focused on conservation, restructuring the Legal and Technical Commission (LTC) to prioritize environmental expertise, and developing funding mechanisms for custodian activities independent of mining revenues. Incorporating a plurality of knowledge systems, meaningful stakeholder participation, and accountability mechanisms would strengthen the legitimacy of the ISA as an institution governing the common heritage of humankind through active environmental stewardship.")
      )
    )
  )

  observeEvent(input$vision_modal_open, {
    v <- input$vision_modal_open
    vc <- vision_content[[v]]
    showModal(modalDialog(
      title     = tags$span(style = "font-size:1.1rem; font-weight:700; color:#1a1a2e;", vc$title),
      size      = "l",
      easyClose = TRUE,
      footer    = modalButton("Close"),
      vc$body
    ))
  })

  # Reset view (network) --------------------------------------------------------
  observeEvent(input$reset_view, {
    visNetworkProxy("network_plot") %>% visFit(animation = FALSE)
  })

  # Reset view (map) ------------------------------------------------------------
  observeEvent(input$reset_map_view, {
    leafletProxy("finding1_map") %>%
      setView(lng = 10, lat = 25, zoom = 2)
  })


  # Reset all filters -----------------------------------------------------------
  observeEvent(input$reset_filter, {
    legend_state$clusters   <- setNames(rep(TRUE, 4), as.character(1:4))
    legend_state$types      <- setNames(rep(TRUE, 6), c("member_state", "regional_group", "observer_ngo", "observer_igo", "isa", "observer_state"))
    comp_state$actor_a      <- NULL
    comp_state$actor_b      <- NULL
    comp_state$color_a      <- "#888888"
    comp_state$color_b      <- "#888888"
    comp_state$next_slot    <- "a"
    updateSelectizeInput(session, "comp_actor_a", selected = "")
    updateSelectizeInput(session, "comp_actor_b", selected = "")
  })

  # Navigate to Statements tab --------------------------------------------------
  observeEvent(input$goto_stmts, {
    actor_nm <- input$goto_stmts
    if (!is.null(actor_nm) && actor_nm != "") {
      # Match against dta_agg (same source as actor_choices values)
      matched <- dta_agg$actor[tolower(dta_agg$actor) == tolower(actor_nm)]
      sel <- if (length(matched) > 0) matched[1] else ""
      updateSelectizeInput(session, "gpt_actor", selected = sel)
      session$sendCustomMessage("goto_statements", list())
    }
  })

  # Legend toggle state ---------------------------------------------------------
  legend_state <- reactiveValues(
    clusters = setNames(rep(TRUE, 4), as.character(1:4)),
    types    = setNames(rep(TRUE, 6), c("member_state", "regional_group", "observer_ngo", "observer_igo", "isa", "observer_state"))
  )
  observeEvent(input$legend_toggle, {
    tog <- input$legend_toggle
    if (tog$category == "cluster") {
      legend_state$clusters[tog$key] <- !legend_state$clusters[tog$key]
    } else {
      legend_state$types[tog$key] <- !legend_state$types[tog$key]
    }
  })

  # ── Comparison module ---------------------------------------------------------

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

    theta_cats <- c("Env. cust.", "Mining reg.", "MSR inst.", "Env. cust.")

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
            paste0("<b>", str_to_title(actor_a), "</b><br>Env. cust.: ",  round(ec_a, 3)),
            paste0("<b>", str_to_title(actor_a), "</b><br>Mining reg.: ", round(mr_a, 3)),
            paste0("<b>", str_to_title(actor_a), "</b><br>MSR inst.: ",   round(si_a, 3)),
            paste0("<b>", str_to_title(actor_a), "</b><br>Env. cust.: ",  round(ec_a, 3))
          ),
          hoverinfo  = "text",
          hoveron    = "points",
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
            paste0("<b>", str_to_title(actor_b), "</b><br>Env. cust.: ",  round(ec_b, 3)),
            paste0("<b>", str_to_title(actor_b), "</b><br>Mining reg.: ", round(mr_b, 3)),
            paste0("<b>", str_to_title(actor_b), "</b><br>MSR inst.: ",   round(si_b, 3)),
            paste0("<b>", str_to_title(actor_b), "</b><br>Env. cust.: ",  round(ec_b, 3))
          ),
          hoverinfo  = "text",
          hoveron    = "points",
          showlegend = FALSE
        )
      }
    }

    # Layout and styling
    p %>% layout(
      polar = list(
        domain      = list(x = c(0.12, 0.88), y = c(0.04, 0.94)),
        radialaxis  = list(range = c(0, 1), visible = TRUE, gridcolor = "#eeeeee", showticklabels = TRUE,
                           tickfont = list(size = 9, color = "#cccccc"), tickcolor = "#cccccc", linecolor = "#eeeeee"),
        angularaxis = list(
          tickfont  = list(size = 10, family = "Lora, serif", color = "#333333"),
          linecolor = "#cccccc",
          gridcolor = "#eeeeee",
          direction = "clockwise",
          rotation  = 90
        ),
        bgcolor = "rgba(0,0,0,0)"
      ),
      showlegend    = FALSE,
      dragmode      = FALSE,
      autosize      = FALSE,
      width         = 310,
      height        = 290,
      margin        = list(l = 20, r = 20, t = 15, b = 5),
      paper_bgcolor = "rgba(0,0,0,0)",
      plot_bgcolor  = "rgba(0,0,0,0)",
      font          = list(family = "Lora, serif", size = 10, color = "#333333")
    ) %>%
    config(displayModeBar = FALSE, scrollZoom = FALSE)
  })

  # Score readout blocks rendered below each dropdown.
  # Always renders (never returns NULL) so the chart doesn't shift when an actor is first selected.
  # Empty state shows 0.00 placeholders with muted styling and an invisible button to hold height.
  make_score_ui <- function(actor_name, border_col, fill_col) {
    empty <- is.null(actor_name) || actor_name == ""
    if (!empty) {
      arow <- dta_agg %>% filter(actor == actor_name)
      if (nrow(arow) == 0) empty <- TRUE
    }

    if (empty) {
      return(
        div(class = "comp-scores", style = "border-color:#e0e0e0;",
          lapply(c("EC", "MR", "SI"), function(lbl) {
            div(class = "comp-score-row",
              span(class = "comp-score-lbl", style = "color:#ddd;", lbl),
              div(class = "comp-score-bar"),
              span(class = "comp-score-val", style = "color:#ddd;", "0.00")
            )
          }),
          tags$button(
            class = "comp-stmts-link", style = "visibility:hidden;",
            bs_icon("arrow-right-short"), "View statements"
          )
        )
      )
    }

    scores <- list(
      list(lbl = "EC", val = round(arow$mean_ec2[1], 2)),
      list(lbl = "MR", val = round(arow$mean_mr2[1], 2)),
      list(lbl = "SI", val = round(arow$mean_si2[1], 2))
    )
    div(class = "comp-scores",
      style = paste0("border-color:", border_col, ";"),
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
        bs_icon("arrow-right-short"), paste0("View ", arow$n_statements[1], " statements")
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

  # ── End comparison module -----------------------------------------------------

  # 3D vision-space scatter -----------------------------------------------------
  output$scatter3d_plot <- renderPlotly(suppressWarnings({

    cluster_cols  <- c("1" = "#CC8A52", "2" = "#8A7ABF",
                       "3" = "#6DB589", "4" = "#5BAAB6")
    cluster_names <- c("1" = "Mining regulator",       "2" = "Mining reg. + Env. cust.",
                       "3" = "Env. cust. + MSR inst.", "4" = "Env. cust. + Mining reg.")
    type_syms     <- c("Member State"   = "circle",        "Regional Group" = "hexagon",
                       "Observer NGO"  = "square",        "Observer IGO"   = "triangle-up",
                       "ISA"           = "diamond",       "Observer State" = "triangle-down")

    active_clusters <- names(which(legend_state$clusters))
    active_types    <- names(which(legend_state$types))

    df <- dta_agg %>%
      filter(!is.na(mean_mr2), !is.na(mean_si2), !is.na(mean_ec2)) %>%
      mutate(actor_id = str_replace_all(actor, " ", "_")) %>%
      left_join(raw_nodes %>% select(id, cluster5), by = c("actor_id" = "id")) %>%
      mutate(
        cluster_key  = as.character(if_else(is.na(cluster5), 1L, as.integer(cluster5))),
        type_key_leg = case_when(
          actor_type_eh2 == "member state"                               ~ "member_state",
          actor_type_eh2 == "regional group"                             ~ "regional_group",
          actor_type_eh2 == "observer ngo"                               ~ "observer_ngo",
          actor_type_eh2 == "observer igo"                               ~ "observer_igo",
          actor_type_eh2 %in% c("isa", "enterprise")                     ~ "isa",
          actor_type_eh2 == "observer state"                             ~ "observer_state",
          TRUE                                                            ~ "member_state"
        )
      ) %>%
      filter(cluster_key %in% active_clusters, type_key_leg %in% active_types) %>%
      mutate(
        label       = str_to_title(actor),
        type_clean  = case_when(
          actor_type_eh2 == "member state"                               ~ "Member State",
          actor_type_eh2 == "regional group"                             ~ "Regional Group",
          actor_type_eh2 == "observer ngo"                               ~ "Observer NGO",
          actor_type_eh2 == "observer igo"                               ~ "Observer IGO",
          actor_type_eh2 %in% c("isa", "enterprise")                     ~ "ISA",
          actor_type_eh2 == "observer state"                             ~ "Observer State",
          TRUE                                                            ~ "Member State"
        ),
        point_sym = type_syms[type_clean],
        hover = paste0(
          "<b>", str_to_title(actor), "</b><br>",
          "Mining reg.: <b>", round(mean_mr2, 3), "</b><br>",
          "MSR inst.:   <b>", round(mean_si2, 3), "</b><br>",
          "Env. cust.:  <b>", round(mean_ec2, 3), "</b>"
        )
      )

    # NOTE: comp_state is NOT a reactive dep here — comparison highlights are
    # updated separately via plotlyProxy so actor clicks never reset the camera.
    p <- plot_ly(source = "scatter3d_src")

    # Traces 0-3: one per cluster, always emitted (even if empty after filtering).
    # Fixed trace count is required so plotlyProxy restyle can target stable indices.
    for (cl in c("1", "2", "3", "4")) {
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
    # Rendered as hollow rings + text labels; updated via plotlyProxy without camera reset.
    for (i in seq_len(2)) {
      p <- p %>% add_trace(
        x = NA_real_, y = NA_real_, z = NA_real_,
        type     = "scatter3d",
        mode     = "markers+text",
        text     = "",
        textposition = "top center",
        textfont = list(size = 12, family = "Lora, serif", color = "#333333"),
        marker   = list(
          color  = "rgba(0,0,0,0)",        # hollow fill
          symbol = "circle",
          size   = 20,
          opacity = 0,
          line   = list(width = 3, color = "#888888")
        ),
        hoverinfo  = "none",
        showlegend = FALSE
      )
    }

    p %>% layout(
      scene = list(
        xaxis = list(title = "Mining reg.", range = c(1, 0),
                     tickfont = list(size = 10), titlefont = list(size = 11),
                     gridcolor = "#e8e8e8", zerolinecolor = "#cccccc"),
        yaxis = list(title = "MSR inst.",   range = c(1, 0),
                     tickfont = list(size = 10), titlefont = list(size = 11),
                     gridcolor = "#e8e8e8", zerolinecolor = "#cccccc"),
        zaxis = list(title = "Env. cust.",  range = c(0, 1),
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
  }))
  outputOptions(output, "scatter3d_plot", suspendWhenHidden = FALSE)

  # Update 3D comparison highlights via proxy -----------------------------------
  observe({
    comp_a <- comp_state$actor_a
    comp_b <- comp_state$actor_b
    col_a  <- comp_state$color_a
    col_b  <- comp_state$color_b

    type_syms_hl <- c(
      "member state"   = "circle",        "regional group" = "hexagon",
      "observer ngo"   = "square",        "observer igo"   = "triangle-up",
      "isa"            = "diamond",       "enterprise"     = "diamond",
      "observer state" = "triangle-down"
    )

    actor_sym <- function(actor_name) {
      row <- dta_agg %>% filter(actor == actor_name)
      if (nrow(row) == 0) return("circle")
      type_syms_hl[row$actor_type_eh2[1]]
    }

    hl_vals <- function(actor_name, color, slot_label) {
      empty <- list(x = NA_real_, y = NA_real_, z = NA_real_,
                    color = color, sym = "circle", opacity = 0,
                    label = "", ht = "")
      if (is.null(actor_name) || actor_name == "") return(empty)
      row <- dta_agg %>% filter(actor == actor_name, !is.na(mean_mr2))
      if (nrow(row) == 0) return(empty)
      list(
        x       = row$mean_mr2[1],
        y       = row$mean_si2[1],
        z       = row$mean_ec2[1],
        color   = color,
        sym     = unname(actor_sym(actor_name)),
        opacity = 1,
        label   = paste0(slot_label, ": ", str_to_title(actor_name)),
        ht      = paste0("<b>", str_to_title(actor_name), "</b><br>",
                         "Mining reg.: ", round(row$mean_mr2[1], 3), "<br>",
                         "MSR inst.: ",   round(row$mean_si2[1], 3), "<br>",
                         "Env. cust.: ",  round(row$mean_ec2[1], 3))
      )
    }

    a <- hl_vals(comp_a, col_a, "A")
    b <- hl_vals(comp_b, col_b, "B")

    plotlyProxy("scatter3d_plot", session) %>%
      plotlyProxyInvoke("restyle",
        list(
          x                       = list(list(a$x),     list(b$x)),
          y                       = list(list(a$y),     list(b$y)),
          z                       = list(list(a$z),     list(b$z)),
          # Hollow ring in slot color wraps around the existing cluster dot
          "marker.color"          = list("rgba(0,0,0,0)", "rgba(0,0,0,0)"),
          "marker.symbol"         = list(a$sym,     b$sym),
          "marker.opacity"        = list(a$opacity, b$opacity),
          "marker.size"           = list(20,        20),
          "marker.line.width"     = list(3,         3),
          "marker.line.color"     = list(a$color,   b$color),
          # Text label above the marker in slot color
          text                    = list(a$label,   b$label),
          "textfont.color"        = list(a$color,   b$color),
          "textfont.size"         = list(11,        11),
          hovertext               = list(a$ht,      b$ht),
          hoverinfo               = list("text",    "text")
        ),
        list(9L, 10L)
      )
  })

  # Network (2D) ----------------------------------------------------------------
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
          type == "vision"                           ~ NA_character_,
          actor_type_eh2 == "member state"           ~ "member_state",
          actor_type_eh2 == "regional group"         ~ "regional_group",
          actor_type_eh2 == "observer ngo"           ~ "observer_ngo",
          actor_type_eh2 == "observer igo"           ~ "observer_igo",
          actor_type_eh2 %in% c("isa", "enterprise") ~ "isa",
          actor_type_eh2 == "observer state"         ~ "observer_state",
          TRUE                                        ~ "member_state"
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

  # Actor scores table ----------------------------------------------------------
  output$actor_table <- renderDT({
    df <- dta_agg
    if (!is.null(input$actor_table_actor) && input$actor_table_actor != "") {
      df <- df %>% filter(actor == input$actor_table_actor)
    }
    df %>%
      mutate(
        Actor = { lkp <- actor_label_lookup[actor]; ifelse(!is.na(lkp), unname(lkp), str_to_title(actor)) },
        across(c(mean_mr2, mean_si2, mean_ec2), ~ round(.x, 3)),
        council_member = ifelse(council_member == 1, "yes", "no")
      ) %>%
      select(
        Actor,
        Type           = actor_type_eh2,
        Statements     = n_statements,
        `Mining reg.`  = mean_mr2,
        `MSR inst.`    = mean_si2,
        `Env. cust.`   = mean_ec2,
        `Moratorium/PP/Sponsor` = morasponsor,
        `Council member` = council_member,
        Region         = regional_group
      ) %>%
      datatable(
        rownames = FALSE,
        options = list(
          pageLength = 20, dom = "tip",
          autoWidth  = FALSE,
          columnDefs = list(
            list(className = "dt-left", targets = "_all"),
            list(
              targets = c(3, 4, 5),
              createdCell = JS("function(td, cellData, rowData, row, col) {
                var v = parseFloat(cellData);
                if (!isNaN(v)) {
                  var pct = (Math.max(0, Math.min(1, v)) * 100).toFixed(1);
                  var clr = {3: '#E3BFA0', 4: '#A5D0D7', 5: '#AFD6BE'}[col] || '#d8d8d8';
                  td.style.background = 'linear-gradient(90deg, ' + clr + ' ' + pct + '%, transparent ' + pct + '%)';
                  td.style.backgroundSize = '100% 17px';
                  td.style.backgroundRepeat = 'no-repeat';
                  td.style.backgroundPosition = '0% 50%';
                }
              }")
            ),
            list(
              targets = 2,
              createdCell = JS("function(td, cellData, rowData, row, col) {
                var actor = rowData[0];
                $(td).addClass('stmts-link-cell').on('click', function(e) {
                  e.stopPropagation();
                  Shiny.setInputValue('goto_stmts', actor, {priority: 'event'});
                });
              }")
            )
          ),
          scrollX = FALSE
        )
      )
  })

  # Statement browser
  gpt_view <- reactive({
    df <- gpt_results
    if (!is.null(input$gpt_actor) && input$gpt_actor != "") df <- df %>% filter(tolower(actor) == tolower(input$gpt_actor))
    df %>%
      select(
        id_statement,
        Actor         = actor,
        Date          = date,
        Forum         = meeting,
        Statement     = statement,
        `Mining reg.` = mining_regulator,
        `MSR inst.`   = science_institution,
        `Env. cust.`  = environmental_custodian
      ) %>%
      mutate(
        Actor = { lkp <- actor_label_lookup[tolower(Actor)]; ifelse(!is.na(lkp), unname(lkp), Actor) },
        across(c(`Mining reg.`, `MSR inst.`, `Env. cust.`), ~ round(.x, 3))
      )
  })

  output$gpt_table <- renderDT({
    datatable(gpt_view(),
      selection = "single", rownames = FALSE,
      options = list(
        pageLength = 10, dom = "ftip", autoWidth = FALSE,
        language = list(search = "", searchPlaceholder = "Search text..."),
        search = list(smart = FALSE, caseInsensitive = TRUE),
        columnDefs = list(
          list(className = "dt-left",  targets = "_all"),
          list(visible = FALSE,        targets = 0),          # id_statement (hidden, for row lookup)
          list(width = "110px",        targets = 1),          # Actor
          list(width = "90px",         targets = 2),          # Date
          list(width = "130px",        targets = 3),          # Forum
          list(width = "auto",         targets = 4),          # Statement
          list(width = "85px",         targets = c(5, 6, 7)), # Scores
          list(
            targets = c(5, 6, 7),
            createdCell = JS("function(td, cellData, rowData, row, col) {
              var v = parseFloat(cellData);
              if (!isNaN(v)) {
                var pct = (Math.max(0, Math.min(1, v)) * 100).toFixed(1);
                var clr = {5: '#E3BFA0', 6: '#A5D0D7', 7: '#AFD6BE'}[col] || '#d8d8d8';
                td.style.background = 'linear-gradient(90deg, ' + clr + ' ' + pct + '%, transparent ' + pct + '%)';
                td.style.backgroundSize = '100% 17px';
                td.style.backgroundRepeat = 'no-repeat';
                td.style.backgroundPosition = '0% 50%';
              }
            }")
          ),
          list(
            targets = 4,
            render = JS("function(data, type, row, meta) {
              if (type !== 'display' || !data) return data;
              var q = new $.fn.dataTable.Api(meta.settings).search();
              if (q && q.length > 0) {
                var idx = data.toLowerCase().indexOf(q.toLowerCase());
                if (idx >= 0) {
                  var start = Math.max(0, idx - 100);
                  var end   = Math.min(data.length, idx + q.length + 100);
                  return (start > 0 ? '…' : '') +
                    data.substring(start, idx) +
                    '<mark style=\"background:#ffe066;padding:0 1px;border-radius:2px\">' +
                    data.substring(idx, idx + q.length) +
                    '</mark>' +
                    data.substring(idx + q.length, end) +
                    (end < data.length ? '…' : '');
                }
              }
              return data.length > 280 ? data.substring(0, 280) + '…' : data;
            }")
          )
        ),
        initComplete = JS("function(settings, json) {
          var $wrap = $(this.api().table().container());
          var $hdr = $('#gpt-hdr-ctrl');
          $hdr.find('.dataTables_filter').remove();
          $hdr.append($wrap.find('.dataTables_filter').detach());
        }")
      )
    )
  })

  # Download handlers — actor scores -----------------------------------------------
  actor_dl_data <- reactive({
    dta_agg %>%
      select(
        Actor          = actor,
        Type           = actor_type_eh2,
        Statements     = n_statements,
        `Mining reg.`  = mean_mr2,
        `MSR inst.`    = mean_si2,
        `Env. cust.`   = mean_ec2,
        `Moratorium/PP/Sponsor` = morasponsor,
        `Council member` = council_member,
        Region         = regional_group
      ) %>%
      mutate(
        Actor = str_to_title(Actor),
        across(c(`Mining reg.`, `MSR inst.`, `Env. cust.`), ~ round(.x, 3)),
        `Council member` = ifelse(`Council member` == 1, "yes", "no")
      )
  })

  output$dl_actor_csv <- downloadHandler(
    filename = "actor_scores.csv",
    content  = function(file) write.csv(actor_dl_data(), file, row.names = FALSE)
  )
  output$dl_actor_excel <- downloadHandler(
    filename = "actor_scores.xlsx",
    content  = function(file) writexl::write_xlsx(actor_dl_data(), file)
  )

  # Download handlers — statements --------------------------------------------------
  stmt_dl_data <- reactive({
    gpt_results %>%
      select(
        Actor         = actor,
        Date          = date,
        Forum         = meeting,
        Statement     = statement,
        `Mining reg.` = mining_regulator,
        `MSR inst.`   = science_institution,
        `Env. cust.`  = environmental_custodian,
        Explanation   = explanation
      ) %>%
      mutate(across(c(`Mining reg.`, `MSR inst.`, `Env. cust.`), ~ round(.x, 3)))
  })

  output$dl_stmt_csv <- downloadHandler(
    filename = "statements.csv",
    content  = function(file) write.csv(stmt_dl_data(), file, row.names = FALSE)
  )
  output$dl_stmt_excel <- downloadHandler(
    filename = "statements.xlsx",
    content  = function(file) writexl::write_xlsx(stmt_dl_data(), file)
  )

  observeEvent(input$gpt_table_rows_selected, {
    req(length(input$gpt_table_rows_selected) > 0)
    sel    <- input$gpt_table_rows_selected
    row_id <- gpt_view()$id_statement[sel]
    row    <- gpt_results %>% filter(id_statement == row_id)

    showModal(modalDialog(
      size = "l", easyClose = TRUE,
      footer = modalButton("Close"),
      title = tagList(
        div(class = "stmt-modal-actor", str_to_title(row$actor)),
        div(class = "stmt-modal-meta",
          paste0(
            row$date, " ", row$time, " · ",
            row$meeting, " · ",
            row$id_statement
          )
        )
      ),
      tagList(
        div(class = "stmt-modal-text", row$statement),
        div(class = "stmt-modal-scores",
          div(class = "stmt-modal-score-item",
            div(class = "stmt-modal-score-label", "Mining reg."),
            div(class = "stmt-modal-score-val",   round(row$mining_regulator, 3))
          ),
          div(class = "stmt-modal-score-item",
            div(class = "stmt-modal-score-label", "MSR inst."),
            div(class = "stmt-modal-score-val",   round(row$science_institution, 3))
          ),
          div(class = "stmt-modal-score-item",
            div(class = "stmt-modal-score-label", "Env. cust."),
            div(class = "stmt-modal-score-val",   round(row$environmental_custodian, 3))
          )
        ),
        div(class = "stmt-modal-expl-label", "Model explanation"),
        div(class = "stmt-modal-expl", row$explanation)
      )
    ))
  })

  # ── Finding 1: development status bars---------------------------------------
  output$finding1_bars <- renderPlotly({
    make_vision_plotly(bar_dev_data, "group")
  })

  # ── Finding 1: geography map (Leaflet choropleth, group-based vision switch)-
  output$finding1_map <- renderLeaflet({
    req(!is.null(world_map_sf))
    # Build labels fresh: htmltools::HTML() class is not reliably preserved
    # through RDS serialisation, so the cached map_labels silently fails.
    .fmt_lbl <- function(x) ifelse(is.na(x), "n/a", sprintf("%.3f", x))
    .map_labels <- mapply(
      function(name, mr, si, ec) {
        htmltools::HTML(paste0(
          "<div style='font-family:Lora,serif;line-height:1.75;font-size:12px'>",
          "<b>", name, "</b><br>",
          "Mining reg.: <b>", .fmt_lbl(mr), "</b><br>",
          "MSR inst.:&nbsp;&nbsp; <b>", .fmt_lbl(si), "</b><br>",
          "Env. cust.:&nbsp;&nbsp; <b>", .fmt_lbl(ec), "</b>",
          "</div>"
        ))
      },
      world_map_sf$sovereignt,
      world_map_sf$mean_mr2,
      world_map_sf$mean_si2,
      world_map_sf$mean_ec2,
      SIMPLIFY = FALSE
    )
    lo <- labelOptions(
      style     = list("border" = "none", "padding" = "4px 8px", "box-shadow" = "none"),
      direction = "auto", sticky = FALSE, offset = c(12, 0)
    )
    hi <- highlightOptions(weight = 2, color = "#333", fillOpacity = 0.95, bringToFront = TRUE)
    m <- leaflet(world_map_sf, options = leafletOptions(minZoom = 2, worldCopyJump = TRUE)) %>%
      setView(lng = 10, lat = 25, zoom = 2)
    for (vis in c("mr", "si", "ec")) {
      cf  <- map_color_fns[[vis]]
      col <- map_pal_cfg[[vis]]$col
      m   <- m %>% addPolygons(
        fillColor      = cf(world_map_sf[[col]]),
        fillOpacity    = 0.82,
        color          = "white",
        weight         = 0.5,
        smoothFactor   = 1.5,
        label          = unname(.map_labels),
        labelOptions   = lo,
        highlightOptions = hi,
        options        = pathOptions(interactive = TRUE),
        group          = vis
      )
    }
    m %>%
      hideGroup("si") %>%
      hideGroup("ec") %>%
      htmlwidgets::onRender(
        "function(el,x){
          var m = this;
          [100,400,900,2000,4000].forEach(function(d){
            setTimeout(function(){ m.invalidateSize(false); }, d);
          });
          if (window.ResizeObserver) {
            new ResizeObserver(function(){ m.invalidateSize(false); }).observe(el);
          }
          var _tip = null;
          m.on('tooltipopen', function(e) {
            if (_tip && _tip !== e.tooltip) { m.closeTooltip(_tip); }
            _tip = e.tooltip;
          });
          m.on('tooltipclose', function(e) {
            if (_tip === e.tooltip) { _tip = null; }
          });
        }"
      )
  })

  observeEvent(input$map_vision, {
    vis <- input$map_vision
    leafletProxy("finding1_map") %>%
      showGroup(vis) %>%
      hideGroup(setdiff(c("mr", "si", "ec"), vis))
  }, ignoreInit = TRUE)

  # ── Finding 2: moratorium / sponsor bars-------------------------------------
  output$finding2_mora_bars <- renderPlotly({
    make_vision_plotly(bar_morasponsor_data, "morasponsor")
  })

  # ── Finding 2: SIDS sponsor bars---------------------------------------------
  output$finding2_sids_bars <- renderPlotly({
    make_vision_plotly(bar_sids_data, "sponsorstate")
  })

  # ── Finding 3: actor type bars-----------------------------------------------
  output$finding3_bars <- renderPlotly({
    make_vision_plotly(bar_type_data, "actor_type_eh2")
  })
}

shinyApp(ui, server)
