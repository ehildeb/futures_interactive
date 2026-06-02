
# ── node_editor.R ─────────────────────────────────────────────────────────────
# Standalone Shiny app for manually adjusting network node positions.
#
# Run from the project root:
#   shiny::runApp("futures_interactive/node_editor.R")
#
# Workflow:
#   1. Drag nodes to adjust positions
#   2. "Save positions" persists them to node_positions_manual.csv
#      (main app picks these up automatically on next restart)
#   3. "Export PNG" produces a high-res PNG via webshot2:
#      - Saves network as self-contained HTML
#      - Injects devicePixelRatio=3 before vis.js initialises (3x canvas buffer)
#      - Injects fit() call so the graph fills the viewport
#      - webshot2 screenshots at zoom=3 (4800x3000px output)
#      - "Download PNG" button appears bottom-right when ready
# ──────────────────────────────────────────────────────────────────────────────

library(shiny)
library(bslib)
library(visNetwork)
library(dplyr)
library(stringr)
library(readr)
library(jsonlite)
library(webshot2)
library(htmlwidgets)

# Shiny sets CWD to the app directory (futures_interactive/) when running
source("global.R")

POSITIONS_FILE <- "node_positions_manual.csv"

# Apply saved positions from previous sessions
if (file.exists(POSITIONS_FILE)) {
  saved <- read_csv(POSITIONS_FILE, show_col_types = FALSE)
  editor_nodes <- net_nodes %>%
    left_join(saved %>% select(id, x_s = x, y_s = y), by = "id") %>%
    mutate(x = coalesce(x_s, x), y = coalesce(y_s, y)) %>%
    select(-x_s, -y_s)
  message("Loaded saved positions for ", nrow(saved), " nodes.")
} else {
  editor_nodes <- net_nodes
}


# ── UI ────────────────────────────────────────────────────────────────────────
ui <- page_fluid(
  theme = bs_theme(bootswatch = "flatly", base_font = font_google("Lora")),

  tags$style(HTML("
    body, html { background: #fff; margin: 0; padding: 0; }
    .toolbar {
      display: flex; align-items: center; gap: 0.65rem;
      padding: 0.55rem 1rem; border-bottom: 1px solid #ddd;
      background: #fafafa; flex-wrap: wrap;
    }
    .toolbar-title { font-size: 0.9rem; font-weight: 700; color: #333; flex: 1; margin: 0; }
    .status-lbl { font-size: 0.75rem; color: #999; font-style: italic; }
  ")),

  div(class = "toolbar",
    tags$span(class = "toolbar-title", "Network Node Position Editor"),
    tags$span(id = "status_lbl", class = "status-lbl",
      if (file.exists(POSITIONS_FILE)) "Saved positions loaded" else "Drag nodes to adjust"
    ),
    actionButton("save_btn",   "Save positions",   class = "btn-sm btn-primary"),
    actionButton("reset_btn",  "Reset to default", class = "btn-sm btn-outline-secondary"),
    actionButton("export_btn", "Export PNG",       class = "btn-sm btn-outline-secondary")
  ),

  visNetworkOutput("network_plot", width = "100%", height = "calc(100vh - 52px)"),

  # Trigger JS -> R positions fetch when export button clicked
  tags$script(HTML("
    $(document).on('click', '#export_btn', function() {
      // Pull latest positions from the live network before R handles the event
      if (window._visNetwork) {
        var pos = window._visNetwork.getPositions();
        Shiny.setInputValue('live_pos', JSON.stringify(pos), {priority: 'event'});
      }
    });

    Shiny.addCustomMessageHandler('set_status', function(msg) {
      var el = document.getElementById('status_lbl');
      if (el) el.textContent = msg;
    });
  ")),

  # Download anchor -- triggered programmatically from server
  uiOutput("download_ui")
)


# ── Server ────────────────────────────────────────────────────────────────────
server <- function(input, output, session) {

  live_positions <- reactiveVal(NULL)

  output$network_plot <- renderVisNetwork({
    editor_nodes %>%
      visNetwork(net_edges, width = "100%") %>%
      visNodes(font = list(size = 11, strokeWidth = 2, strokeColor = "#ffffff")) %>%
      visEdges(smooth = FALSE, color = list(color = "rgba(0,0,0,0.08)")) %>%
      visPhysics(enabled = FALSE) %>%
      visInteraction(
        dragNodes         = TRUE,
        dragView          = TRUE,
        zoomView          = TRUE,
        navigationButtons = FALSE,
        tooltipDelay      = 150
      ) %>%
      visOptions(highlightNearest = FALSE, nodesIdSelection = FALSE) %>%
      visEvents(
        afterDrawing = "function() { window._visNetwork = this; }",
        dragEnd      = "function(params) {
          window._visNetwork = this;
          var pos = this.getPositions();
          Shiny.setInputValue('live_pos', JSON.stringify(pos), {priority: 'event'});
        }"
      )
  })

  # Parse and store positions after each drag (or before export)
  observeEvent(input$live_pos, {
    raw <- fromJSON(input$live_pos)
    pos_df <- tibble(
      id = names(raw),
      x  = sapply(raw, `[[`, "x"),
      y  = sapply(raw, `[[`, "y")
    )
    live_positions(pos_df)
    session$sendCustomMessage("set_status",
      paste0(nrow(pos_df), " positions captured (unsaved)"))
  })

  # Save positions to CSV
  observeEvent(input$save_btn, {
    pos <- live_positions()
    if (is.null(pos)) {
      showNotification("Drag at least one node first.", type = "warning")
      return()
    }
    write_csv(pos, POSITIONS_FILE)
    showNotification(
      paste0("Saved ", nrow(pos), " positions to ", POSITIONS_FILE,
             ". Restart the main app to apply."),
      type = "message", duration = 6
    )
    session$sendCustomMessage("set_status",
      paste0("Saved ", nrow(pos), " positions -- restart main app to apply"))
  })

  # Reset: delete saved file and reload editor
  observeEvent(input$reset_btn, {
    if (file.exists(POSITIONS_FILE)) file.remove(POSITIONS_FILE)
    session$reload()
  })

  # ── Export: rebuild network with current positions, screenshot via webshot2 ──
  export_file <- reactiveVal(NULL)

  observeEvent(input$export_btn, {
    pos <- live_positions()

    # Use saved positions if no drag has happened yet this session
    if (is.null(pos) && file.exists(POSITIONS_FILE)) {
      pos <- read_csv(POSITIONS_FILE, show_col_types = FALSE)
    }

    session$sendCustomMessage("set_status", "Rendering export...")

    nodes_export <- if (!is.null(pos)) {
      editor_nodes %>%
        left_join(pos %>% select(id, x_new = x, y_new = y), by = "id") %>%
        mutate(x = coalesce(x_new, x), y = coalesce(y_new, y)) %>%
        select(-any_of(c("x_new", "y_new")))
    } else {
      editor_nodes
    }

    # Build the same network as the editor and save to a temp HTML
    html_file <- tempfile(fileext = ".html")
    png_file  <- tempfile(fileext = ".png")

    nodes_export %>%
      visNetwork(net_edges, width = "100%", height = "100vh") %>%
      visNodes(font = list(size = 11, strokeWidth = 2, strokeColor = "#ffffff")) %>%
      visEdges(smooth = FALSE, color = list(color = "rgba(0,0,0,0.08)")) %>%
      visPhysics(enabled = FALSE) %>%
      visInteraction(dragNodes = FALSE, dragView = FALSE, zoomView = FALSE) %>%
      visOptions(highlightNearest = FALSE, nodesIdSelection = FALSE) %>%
      visSave(file = html_file, selfcontained = TRUE)

    # Inject into saved HTML:
    # 1. Override devicePixelRatio=3 BEFORE vis.js initialises (so its canvas is 3x)
    # 2. Call fit() after render so the network fills the viewport
    html_txt <- paste(readLines(html_file, warn = FALSE), collapse = "\n")

    html_txt <- sub(
      "<head>",
      '<head><script>Object.defineProperty(window,"devicePixelRatio",{get:function(){return 3;}});</script>',
      html_txt
    )
    html_txt <- sub(
      "</body>",
      '<script>
        setTimeout(function() {
          var els = document.querySelectorAll(".visNetwork");
          els.forEach(function(el) {
            var inst = HTMLWidgets.getInstance(el);
            if (inst && inst.network) inst.network.fit({ animation: false });
          });
        }, 800);
      </script>\n</body>',
      html_txt
    )
    writeLines(html_txt, html_file)

    # zoom=3 triples device pixel ratio -- same layout, 3x sharper pixels
    webshot2::webshot(
      url    = paste0("file:///", normalizePath(html_file, winslash = "/")),
      file   = png_file,
      vwidth = 1600,
      vheight = 1000,
      delay  = 2,
      zoom   = 3
    )

    file.remove(html_file)

    if (file.exists(png_file)) {
      export_file(png_file)
      session$sendCustomMessage("set_status", "Export ready -- click Download PNG")
    } else {
      session$sendCustomMessage("set_status", "Export failed")
      showNotification("webshot2 export failed.", type = "error")
    }
  })

  # Show a download button once the PNG is ready
  output$download_ui <- renderUI({
    req(export_file())
    div(style = "position:fixed; bottom:1rem; right:1rem; z-index:9999;",
      downloadButton("dl_btn", "Download PNG", class = "btn-success")
    )
  })

  output$dl_btn <- downloadHandler(
    filename = function() paste0("network_", format(Sys.time(), "%Y-%m-%d_%H-%M-%S"), ".png"),
    content  = function(file) {
      f <- export_file()
      req(f, file.exists(f))
      file.copy(f, file)
    },
    contentType = "image/png"
  )

}

shinyApp(ui, server)
