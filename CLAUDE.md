# ISA Futures Paper — Interactive Shiny Dashboard

## Project Overview

Interactive web dashboard for a peer-review paper on **institutional visions at the International Seabed Authority (ISA)** in deep-sea mining governance. The paper uses LLM-coded statements from ISA Assembly/Council meetings to score actors on three competing institutional visions.

**Paper status:** RR1 submitted to *Geopolitics* (Taylor & Francis), Submission ID 251415075. Content may change; keep Shiny code loosely coupled to data.

---

## Research Summary

The paper combines a **futuring approach** with **discursive institutionalism** to construct three alternative visions for the ISA and empirically map where the "discursive seeds" of these visions already exist in ISA negotiations. "Discursive seeds" = implicit or explicit ideas about the ISA's priorities and role as articulated in negotiations, from which alternative futures may take shape.

**Three visions** (scored 0-1 per actor):
1. **Mining Regulator (MR)** `pal_mr = "#B63F7B"`: ISA as mining facilitation/regulation body
2. **MSR Institution (SI)** `pal_si = "#3F9BA8"`: ISA as a marine science institution
3. **Environmental Custodian (EC)** `pal_ec = "#4BAF67"`: ISA as an environmental protection body

**Key comparisons:** Development status (Developed/Developing/LDCs/LLDCs/SIDS), Moratorium vs. Sponsor states, SIDS sponsor vs. non-sponsor, Council membership, Regional groups (5), Actor types (Member state / Observer NGO / ISA SG).

**Core findings:**
- Vision scores do NOT map to geography or development status
- Sponsorship (vested interests) explains alignment better: sponsoring states score higher on MR, moratorium/PP states score higher on EC and MSR
- ISA Secretary-General scores substantially higher on MR than member states; lower on EC — gap with both member states and civil society
- EC and MSR institution are positively correlated (r = 0.41); MR negatively correlated with EC (r = -0.67) and MSR (r = -0.32)

---

## Data

| File | Description |
|------|-------------|
| `paper_code/working_data/dta_agg_SUBMITTED.csv` | One row per actor. Key cols: `actor`, `actor_type_eh2`, `mean_mr2`, `mean_si2`, `mean_ec2`, `n_statements`, `morasponsor`, `morastate`, `sponsorstate`, `council_member`, `regional_group`, `isa_member` |
| `paper_code/working_data/un_countries.csv` | UN development categories: Developed / Developing / LDCs / LLDCs / SIDS |
| `paper_code/gephi/nodes.csv` + `edges.csv` | Network data exported from Gephi. Edges to `mr`, `si`, `ec` nodes carry vision weights. `cluster4` column on nodes (was `cluster5` before RR1). |
| `paper_code/gpt_results/results_parsed_20251128_212532.csv` | Statement-level LLM output: per-statement MR/SI/EC scores + explanation |
| `paper_code/gpt_results/understandings.xlsx` | Scale and vision definition text used in the app |

**Dataset (RR1):**
- Source: ISA 30th Session (2025) — Part I Council (March 17-28) + Part II Council and Assembly (July 7-25)
- 799 raw statements by 110 actors; filtered to **505 substantive statements across 97 actors**
- Formal settings only (not Mining Code text negotiations)
- LLM scoring model: **GPT-5 Mini**
- Vision scores are 0-1; zero-values excluded from actor means to avoid pulling averages down
- African Group assigned the mean score of the group; states that also spoke individually get combined mean
- ISA actor in Figure 5 is now **ISA SG** (Secretary-General only) — not an average of all ISA representatives
- `set.seed(42)` used for node jitter in global.R (reproducible layout)

---

## App Structure

```
futures_interactive/
  app.R        # UI + server (all CSS inline as `css` string at top)
  global.R     # data loading, network layout, make_group_data()
  CLAUDE.md    # this file
```

No modules/ directory. Everything is in two files.

### Tabs

**Findings tab** (`nav_panel("Findings")`)
- Paper header + intro text
- Network visualisation appears after intro text
- Introduction, Visions, Findings h2, and Implications h2 sections all live in `div(class = "paper paper-last")` below the network
- Three-visions explainer grid (`.visions-grid`, `.vision-card`)
- **3D vision-space scatter** (plotly, see below) — above the 2D network
- **2D visNetwork** — barycentric layout, cluster shapes/greyscale, slider filters
- Finding sections with floated chart placeholders (lorem ipsum)

**Data tab** (`nav_panel("Data")`)
- Sub-tabs: Actor Scores + Statements
- Both use `card(fill = FALSE, ...)` to prevent internal card scroll
- Download buttons + search bar injected into card header via `initComplete` JS

---

## Shiny Implementation Details

### global.R

- `dta_agg`: main actor-level data, joined with `un_countries` for dev status
- `make_group_data(grouping, data = dta_agg)`: returns grouped bar chart data for one of 6 groupings. Accepts a filtered `data` arg for scoped comparisons.
- `raw_nodes`: raw Gephi node table — used for cluster5 join in 3D scatter
- `pole_coords`: vision pole fixed positions — EC=(-700,0), MR=(700,0), SI=(0,600)
- `actor_pos`: barycentric positions from Gephi edge weights
- `nudge_apart(nodes, min_dist=45, jitter=35, iters=120)`: two-phase node separation. Uses `nodes$x <- x` (NOT `mutate`) to avoid dplyr data-masking bug.
- `net_nodes`: node table with shape/color/size assigned by cluster. Vision nodes = white diamonds; actor nodes use greyscale.
- `net_edges`: edges to the 3 vision poles, filtered to `weight >= 0.05`

### 3D Vision-Space Scatter (plotly)

Each actor plotted at `(mean_mr2, mean_si2, mean_ec2)`. Built as **one trace per cluster** so the legend cleanly shows cluster colour entries. Symbol (shape) is set per-point from actor type.

**IMPORTANT (RR1):** Clusters changed from k=5 to k=4. Update `cluster5` join to `cluster4` in the data and reduce traces from 5 clusters to 4. The trace count in the fixed-order scheme (currently 11 traces) needs adjustment.

**Previous 5-cluster colours (for reference only — now superseded):**
| Cluster | Colour | Hex |
|---------|--------|-----|
| 1 | Green | `#4BAF67` |
| 2 | Pink | `#B63F7B` |
| 3 | Teal | `#3F9BA8` |
| 4 | Orange | `#E8821A` |
| 5 | Purple | `#7B5CB8` |

**Symbol by actor type:**
| Type | Symbol |
|------|--------|
| Member State | circle |
| Observer NGO | square |
| ISA | diamond |
| Other | cross |

**Implementation pattern:** build with `plot_ly()` + `add_trace()` loop. Always emits traces in fixed order to support proxy updates:
- Traces 0-3: one per cluster (k=4 now; was 0-4 for k=5). Empty clusters get an invisible NA placeholder.
- Traces 4-7: 4 dummy type-legend entries (NA data, grey) — index shift from k=5 era
- Traces 8-9: comparison highlight placeholders (invisible on init, updated by `plotlyProxy`)

`comp_state` is **not** a reactive dependency inside `renderPlotly` — this prevents camera resets. Instead, a separate `observe` calls `plotlyProxyInvoke("restyle", update, list(9L, 10L))` to update just the comparison traces without re-rendering.

**Camera persistence:** `uirevision = "stable"` is set **inside** `scene = list(...)`, not at the top level. Top-level `uirevision` breaks 3D drag interactions.

**Cluster join:** `dta_agg` joined to `raw_nodes` on `str_replace_all(actor, " ", "_") == id`.

### 2D Network (visNetwork)

- Rendered once with `renderVisNetwork` (all nodes initially visible)
- Slider filtering uses `visNetworkProxy` + `visUpdateNodes` with `hidden` column — avoids zoom reset
- Physics disabled; layout is purely coordinate-based (barycentric + nudge_apart)
- Greyscale by spatial cluster position (EC-left = light, MR-right = dark)

### Data Tab — DT Tables

**Score bars:** use `createdCell` JS in `columnDefs` (NOT `formatStyle` + `styleColorBar`). The `styleColorBar` approach fails because it returns an inline `background` shorthand that resets `background-position`, making bars appear right-aligned regardless of the `backgroundPosition` param. Fix: set all four background properties atomically in a single JS callback:
```javascript
function(td, cellData, rowData, row, col) {
  var v = parseFloat(cellData);
  if (!isNaN(v)) {
    var pct = (Math.max(0, Math.min(1, v)) * 100).toFixed(1);
    td.style.background = 'linear-gradient(90deg, #d8d8d8 ' + pct + '%, transparent ' + pct + '%)';
    td.style.backgroundSize = '100% 65%';
    td.style.backgroundRepeat = 'no-repeat';
    td.style.backgroundPosition = '0% 50%';
  }
}
```

**Controls in card header:** `initComplete` JS detaches `.dt-buttons` and `.dataTables_filter` from the DT wrapper and appends them to a pre-existing `#target-id` div in the card header.

**Pagination:** styled via Bootstrap 5 classes `.page-link` / `.page-item` — NOT `.paginate_button` (which carries no visual style in BS5 + flatly).

**Statements tab specifics:**
- No column filters (`filter = "top"` removed); global search moved to card header
- `table-layout: fixed` with `overflow: hidden` on td for fixed row height
- Statement text truncated at 280 chars via DT `render` JS (preserves full text for search)
- Row click → `showModal` with full statement, three scores, and model explanation
- DO NOT use `display: -webkit-box` on `td` — overrides `display: table-cell` and breaks layout
- **Inline links in prose:** htmltools adds a space between every sibling child in a tag, so `tags$a("text"), "."` renders as `text .` with an unwanted space. Always use `tags$p(HTML('prose with <a href="...">link</a>. more prose'))` for any paragraph that contains inline links or punctuation adjacent to a tag.

### Actor Comparison Module

Sits inside `.network-section` as a sibling to `.net-canvas-box`.

**Layout (responsive):**
- `>= 1200px`: `.network-section` is `flex-direction: row` — comparison panel is a 272px right column
- `< 1200px`: `.network-section` is `flex-direction: column` — comparison panel is below, with `.comp-controls` (210px, left) and `.comp-chart-area` (flex:1, right) side by side

**Components:**
- `.comp-controls`: title label + hint + two `.comp-slot` rows (badge + selectizeInput)
- `.comp-chart-area`: holds `plotlyOutput("comp_plot_combined")`
- Server: `comp_state` reactiveValues (`actor_a`, `actor_b`, `next_slot`)

**Click-to-compare:** visNetwork fires `input$network_node_click` via `visEvents`. 3D scatter uses `source = "scatter3d_src"` + `customdata = ~actor`; server uses `event_data("plotly_click", source = "scatter3d_src")`. Clicks alternate between slots A and B.

**Highlighting:** `visNetworkProxy` + `visUpdateNodes` sets coloured borders (`#2C3E6B` for A, `#B63F7B` for B, `borderWidth = 4`) on selected nodes. 3D scatter adds extra highlighted traces on top of cluster traces.

**Reset:** `observeEvent(input$reset_filter, ...)` also clears `comp_state` and updates both selectize dropdowns.

### Plotly Interactivity Rules

**CRITICAL — drag-to-zoom must NEVER be enabled on bar charts or any static 2D plot.**
Always set `dragmode = FALSE` in `layout()` for every `plot_ly` / `subplot` call that is not intentionally zoomable (bar charts, polar/radar charts).
Also set `fixedrange = TRUE` on ALL axes (x and y) in those charts.
Exceptions (intentionally interactive): visNetwork (drag/pan), leaflet map (zoom/pan), 3D scatter (rotate/zoom).
This rule applies globally — every new Plotly chart added to this project must include `dragmode = FALSE` unless it is an explicitly zoomable/pannable visualisation.

### CSS Architecture

All CSS in the `css` string at the top of app.R.

| Class | Purpose |
|-------|---------|
| `.paper` | Centred paper column (max-width: 860px) |
| `.paper-header` | Title block with bottom border |
| `.network-section` | Responsive flex container with outer border — row on >= 1200px, column below |
| `.net-canvas-box` | Plot area + legend, flex: 1, border-right on wide screens |
| `.net-legend-side` | 158px right-side legend with CSS-swatch items (`.lgd-sw`, `.lgd-circle`, `.lgd-square`, `.lgd-diamond`, `.lgd-tri`) |
| `.comparison-section` | Actor comparison — right column (272px) on wide, below-row on narrow |
| `.comp-controls` | Left/top panel: title, hint, two slot dropdowns |
| `.comp-chart-area` | Flex:1 area holding the combined polar chart |
| `.visions-grid` | 3-column grid for vision explainer cards |
| `.data-tab` | Data tab wrapper with padding |
| `.dt-hdr-ctrl` | Flex container for controls injected into card headers |

**Theme:** `bs_theme(bootswatch="flatly")` with Lora (Google Font). Primary overridden to `#2C3E6B`. Flatly's teal (`#18BC9C`) bleeds into DT pagination — override with `.page-link` / `.page-item`, not `.paginate_button`.

---

## Removed/Dormant Features

### Network "i" info button (removed, easy to restore)

A small circular button in the top-left of `.net-plot-area` that triggers a modal popup explaining the network visualisation. Removed to keep the UI clean for now.

**To restore:**

1. **CSS** (add inside the `css` string, e.g. after the `.view-btn-group` block):
```css
/* Network info button (top-left of plot area) */
.net-info-btn {
  width: 1.65rem;
  height: 1.65rem;
  background: #fff;
  border: 1px solid #ccc;
  border-radius: 50%;
  cursor: pointer;
  color: #555;
  font-family: inherit;
  font-size: 0.82rem;
  font-style: italic;
  font-weight: 700;
  display: flex;
  align-items: center;
  justify-content: center;
  line-height: 1;
  padding: 0;
  transition: background 0.12s, color 0.12s;
}
.net-info-btn:hover { background: #f5f5f5; color: #1a1a2e; }
```

2. **UI** (add as first child inside `div(class = "net-plot-area", ...)`):
```r
div(class = "view-btn-group", style = "left: 0.6rem; right: auto;",
  tags$button(class = "net-info-btn", title = "About this visualisation",
    onclick = "Shiny.setInputValue('network_info_open', 1, {priority: 'event'})",
    "i"
  )
),
```

3. **Server** (add anywhere in the server function, e.g. near the other modal observers):
```r
observeEvent(input$network_info_open, {
  showModal(modalDialog(
    title     = tags$span(style = "font-size:1.1rem; font-weight:700; color:#1a1a2e;",
                          "About this visualisation"),
    size      = "m",
    easyClose = TRUE,
    footer    = modalButton("Close"),
    tags$p("[Edit this text to describe the network visualisation]")
  ))
})
```

---

## Status

- [x] App skeleton (`futures_interactive/app.R` + `futures_interactive/global.R`)
- [x] 2D network (visNetwork, barycentric layout, proxy-filtered by vision score sliders)
- [x] 3D vision-space scatter (plotly, colour by cluster, shape by actor type, labels visible)
- [x] Actor Scores table (DT, grey bars, download + search in card header)
- [x] Statements browser (fixed-height rows, click-to-modal, actor filter + search in header)
- [x] Paper-aesthetic styling (Lora font, navy/white, custom pagination)
- [x] Findings tab skeleton (lorem ipsum text, floated chart placeholders)
- [x] Actor comparison module (polar overlay chart, click-to-select, network/3D highlights, responsive layout)
- [x] Legend overhaul (CSS swatches replacing Unicode symbols)
- [ ] World maps tab
- [ ] Replace lorem ipsum with actual paper content
- [ ] Wire floated chart placeholders to actual plotly bar charts

## Running the App

```r
# From the project root:
shiny::runApp("futures_interactive/")
```

R path on this machine: `C:\Program Files\R\R-4.4.2\bin\Rscript.exe`

---

## K-means Cluster Reference (k=4, set.seed(42)) — updated in RR1

**Changed in RR1:** Clusters reduced from 5 to **4** after removing the ITLOS node and updating the node-position algorithm. The 3D scatter `cluster5` column/colours will need updating to reflect `cluster4`.

Clusters ordered left-to-right in 2D network (EC pole left, MR pole right), based on paper description:

| Cluster | Paper label | Spatial position | Typical profile |
|---------|-------------|-----------------|-----------------|
| 1 (green) | Group 1 | EC-left | High EC, low MR, moderate-high MSR. Most NGOs, some EU/LAC/SIDS countries |
| 2 (blue) | Group 2 | Centre-left | High EC, moderately high MSR and MR |
| 3 (purple) | Group 3 | Centre-right | High MR, moderate EC and MSR. Many sponsoring states, African Group |
| 4 | Group 4 | MR-right | High MR, low-moderate others. Includes ISA SG, Council President, LTC/FC chairs |

**Note:** Exact hex colours and 2D greyscale mappings for the 4-cluster solution need to be set when updating the app. The 3D scatter currently uses 5-cluster colours — update `cluster5` join to `cluster4`.

Vision pole nodes (2D only): white diamonds (`#FFFFFF`), size 36, fixed position.
