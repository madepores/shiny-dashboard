library(shiny)
library(ggplot2)
library(dplyr)

# ── UI ──────────────────────────────────────────────────────────────────────
ui <- fluidPage(
  tags$head(
    tags$link(
      href = "https://fonts.googleapis.com/css2?family=Space+Mono:wght@400;700&family=Syne:wght@400;700;800&display=swap",
      rel = "stylesheet"
    ),
    tags$style(HTML("
      :root {
        --bg:       #0d0f14;
        --surface:  #151820;
        --border:   #252933;
        --accent:   #e8ff47;
        --accent2:  #47c8ff;
        --text:     #e8eaf0;
        --muted:    #666d80;
        --danger:   #ff6b6b;
      }

      * { box-sizing: border-box; margin: 0; padding: 0; }

      body {
        background: var(--bg);
        color: var(--text);
        font-family: 'Syne', sans-serif;
        min-height: 100vh;
      }

      /* ── Header ── */
      .app-header {
        padding: 28px 40px 20px;
        border-bottom: 1px solid var(--border);
        display: flex;
        align-items: baseline;
        gap: 16px;
      }
      .app-header h1 {
        font-size: 26px;
        font-weight: 800;
        letter-spacing: -0.5px;
        color: var(--text);
      }
      .app-header .tag {
        font-family: 'Space Mono', monospace;
        font-size: 10px;
        background: var(--accent);
        color: #0d0f14;
        padding: 2px 8px;
        border-radius: 2px;
        font-weight: 700;
        letter-spacing: 1px;
      }

      /* ── Layout ── */
      .app-body {
        display: grid;
        grid-template-columns: 260px 1fr;
        min-height: calc(100vh - 73px);
      }

      /* ── Sidebar ── */
      .sidebar {
        padding: 28px 24px;
        border-right: 1px solid var(--border);
        display: flex;
        flex-direction: column;
        gap: 28px;
      }
      .sidebar-label {
        font-family: 'Space Mono', monospace;
        font-size: 10px;
        color: var(--muted);
        letter-spacing: 2px;
        text-transform: uppercase;
        margin-bottom: 10px;
      }

      /* inputs */
      .form-control, select.form-control {
        background: var(--surface) !important;
        border: 1px solid var(--border) !important;
        color: var(--text) !important;
        border-radius: 4px !important;
        font-family: 'Space Mono', monospace !important;
        font-size: 12px !important;
        padding: 8px 12px !important;
        transition: border-color .2s;
        width: 100%;
      }
      .form-control:focus, select.form-control:focus {
        outline: none !important;
        border-color: var(--accent) !important;
        box-shadow: none !important;
      }
      .selectize-control .selectize-input {
        background: var(--surface) !important;
        border: 1px solid var(--border) !important;
        color: var(--text) !important;
        border-radius: 4px !important;
        font-family: 'Space Mono', monospace !important;
        font-size: 12px !important;
      }
      .selectize-dropdown {
        background: var(--surface) !important;
        border: 1px solid var(--border) !important;
        color: var(--text) !important;
        font-family: 'Space Mono', monospace !important;
        font-size: 12px !important;
      }
      .selectize-dropdown .active { background: var(--border) !important; }

      label { color: var(--muted) !important; font-size: 12px !important; font-family: 'Space Mono', monospace !important; }

      /* slider */
      .irs--shiny .irs-bar { background: var(--accent) !important; border-top: 1px solid var(--accent) !important; border-bottom: 1px solid var(--accent) !important; }
      .irs--shiny .irs-handle { background: var(--accent) !important; border: 2px solid var(--bg) !important; }
      .irs--shiny .irs-from, .irs--shiny .irs-to, .irs--shiny .irs-single { background: var(--accent) !important; color: #0d0f14 !important; font-family: 'Space Mono', monospace !important; font-size: 11px !important; }
      .irs--shiny .irs-line { background: var(--border) !important; }
      .irs--shiny .irs-grid-text { color: var(--muted) !important; font-family: 'Space Mono', monospace !important; }

      /* checkboxes */
      .checkbox label { color: var(--text) !important; font-family: 'Syne', sans-serif !important; font-size: 13px !important; }

      /* ── Main ── */
      .main-content { padding: 28px 36px; }

      /* KPI row */
      .kpi-row {
        display: grid;
        grid-template-columns: repeat(3, 1fr);
        gap: 16px;
        margin-bottom: 28px;
      }
      .kpi-card {
        background: var(--surface);
        border: 1px solid var(--border);
        border-radius: 6px;
        padding: 20px 24px;
        position: relative;
        overflow: hidden;
      }
      .kpi-card::after {
        content: '';
        position: absolute;
        top: 0; left: 0; right: 0;
        height: 2px;
        background: var(--accent);
      }
      .kpi-card:nth-child(2)::after { background: var(--accent2); }
      .kpi-card:nth-child(3)::after { background: var(--danger); }
      .kpi-label {
        font-family: 'Space Mono', monospace;
        font-size: 10px;
        color: var(--muted);
        letter-spacing: 2px;
        text-transform: uppercase;
        margin-bottom: 8px;
      }
      .kpi-value {
        font-size: 32px;
        font-weight: 800;
        letter-spacing: -1px;
        line-height: 1;
      }
      .kpi-sub {
        font-family: 'Space Mono', monospace;
        font-size: 11px;
        color: var(--muted);
        margin-top: 6px;
      }

      /* Chart panels */
      .chart-grid {
        display: grid;
        grid-template-columns: 1fr 1fr;
        gap: 20px;
        margin-bottom: 20px;
      }
      .panel {
        background: var(--surface);
        border: 1px solid var(--border);
        border-radius: 6px;
        padding: 20px 22px;
      }
      .panel-full { grid-column: 1 / -1; }
      .panel-title {
        font-family: 'Space Mono', monospace;
        font-size: 10px;
        color: var(--muted);
        letter-spacing: 2px;
        text-transform: uppercase;
        margin-bottom: 16px;
        display: flex;
        align-items: center;
        gap: 8px;
      }
      .panel-title::before {
        content: '▸';
        color: var(--accent);
      }

      .shiny-plot-output { width: 100% !important; }

      /* table */
      .dataTable { width: 100% !important; }
      table.dataTable { background: transparent !important; color: var(--text) !important; font-family: 'Space Mono', monospace !important; font-size: 11px !important; }
      table.dataTable thead th { background: var(--bg) !important; color: var(--muted) !important; border-bottom: 1px solid var(--border) !important; letter-spacing: 1px; }
      table.dataTable tbody tr { background: transparent !important; }
      table.dataTable tbody tr:hover { background: var(--border) !important; }
      table.dataTable tbody td { border-top: 1px solid var(--border) !important; }
      .dataTables_wrapper .dataTables_info, .dataTables_wrapper .dataTables_length label,
      .dataTables_wrapper .dataTables_filter label { color: var(--muted) !important; font-family: 'Space Mono', monospace !important; font-size: 11px !important; }
      .dataTables_wrapper .dataTables_paginate .paginate_button { color: var(--muted) !important; }
      .dataTables_wrapper .dataTables_paginate .paginate_button.current { background: var(--accent) !important; color: #0d0f14 !important; border: none !important; }
    "))
  ),

  # Header
  div(class = "app-header",
    h1("Sales Analytics"),
    span(class = "tag", "DASHBOARD")
  ),

  # Body
  div(class = "app-body",

    # Sidebar
    div(class = "sidebar",

      div(
        div(class = "sidebar-label", "Date Range"),
        sliderInput("year_range", NULL,
          min = 2020, max = 2024, value = c(2021, 2024), sep = "")
      ),

      div(
        div(class = "sidebar-label", "Region"),
        selectInput("region", NULL,
          choices = c("All", "North", "South", "East", "West"),
          selected = "All")
      ),

      div(
        div(class = "sidebar-label", "Category"),
        checkboxGroupInput("category", NULL,
          choices = c("Electronics", "Clothing", "Food", "Books"),
          selected = c("Electronics", "Clothing", "Food", "Books"))
      )
    ),

    # Main
    div(class = "main-content",

      # KPIs
      div(class = "kpi-row",
        div(class = "kpi-card",
          div(class = "kpi-label", "Total Revenue"),
          div(class = "kpi-value", textOutput("kpi_revenue", inline = TRUE)),
          div(class = "kpi-sub", "USD")
        ),
        div(class = "kpi-card",
          div(class = "kpi-label", "Total Orders"),
          div(class = "kpi-value", textOutput("kpi_orders", inline = TRUE)),
          div(class = "kpi-sub", "transactions")
        ),
        div(class = "kpi-card",
          div(class = "kpi-label", "Avg Order Value"),
          div(class = "kpi-value", textOutput("kpi_aov", inline = TRUE)),
          div(class = "kpi-sub", "USD per order")
        )
      ),

      # Charts
      div(class = "chart-grid",

        div(class = "panel",
          div(class = "panel-title", "Revenue by Year"),
          plotOutput("plot_trend", height = "220px")
        ),

        div(class = "panel",
          div(class = "panel-title", "Category Breakdown"),
          plotOutput("plot_category", height = "220px")
        ),

        div(class = "panel panel-full",
          div(class = "panel-title", "Region Performance"),
          plotOutput("plot_region", height = "200px")
        )
      )
    )
  )
)

# ── Server ───────────────────────────────────────────────────────────────────
server <- function(input, output, session) {

  # ── Synthetic data ──
  set.seed(42)
  raw_data <- expand.grid(
    year     = 2020:2024,
    region   = c("North", "South", "East", "West"),
    category = c("Electronics", "Clothing", "Food", "Books")
  ) %>%
    mutate(
      orders  = sample(80:500, n(), replace = TRUE),
      revenue = orders * runif(n(), 40, 350)
    )

  # ── Reactive filtered data ──
  filtered <- reactive({
    d <- raw_data %>%
      filter(
        year >= input$year_range[1],
        year <= input$year_range[2],
        category %in% input$category
      )
    if (input$region != "All") d <- d %>% filter(region == input$region)
    d
  })

  # ── KPIs ──
  output$kpi_revenue <- renderText({
    v <- sum(filtered()$revenue)
    paste0("$", formatC(v / 1e6, format = "f", digits = 2), "M")
  })
  output$kpi_orders <- renderText({
    formatC(sum(filtered()$orders), format = "d", big.mark = ",")
  })
  output$kpi_aov <- renderText({
    d <- filtered()
    if (nrow(d) == 0) return("—")
    paste0("$", round(sum(d$revenue) / sum(d$orders), 0))
  })

  # ── Plot theme ──
  dark_theme <- theme_minimal(base_family = "mono") +
    theme(
      plot.background  = element_rect(fill = "#151820", color = NA),
      panel.background = element_rect(fill = "#151820", color = NA),
      panel.grid.major = element_line(color = "#252933", linewidth = 0.4),
      panel.grid.minor = element_blank(),
      axis.text        = element_text(color = "#666d80", size = 9),
      axis.title       = element_blank(),
      legend.background = element_rect(fill = "#151820", color = NA),
      legend.text      = element_text(color = "#666d80", size = 9),
      legend.title     = element_blank()
    )

  pal <- c("#e8ff47", "#47c8ff", "#ff6b6b", "#b47fff")

  # ── Trend ──
  output$plot_trend <- renderPlot({
    filtered() %>%
      group_by(year) %>%
      summarise(revenue = sum(revenue) / 1e6) %>%
      ggplot(aes(factor(year), revenue, group = 1)) +
      geom_area(fill = "#e8ff4720", color = NA) +
      geom_line(color = "#e8ff47", linewidth = 1.4) +
      geom_point(color = "#e8ff47", size = 3, fill = "#0d0f14", shape = 21, stroke = 2) +
      scale_y_continuous(labels = function(x) paste0("$", x, "M")) +
      dark_theme
  }, bg = "#151820")

  # ── Category ──
  output$plot_category <- renderPlot({
    filtered() %>%
      group_by(category) %>%
      summarise(revenue = sum(revenue) / 1e6) %>%
      ggplot(aes(reorder(category, revenue), revenue, fill = category)) +
      geom_col(width = 0.6) +
      coord_flip() +
      scale_fill_manual(values = pal) +
      scale_x_discrete(expand = c(0, 0.5)) +
      scale_y_continuous(labels = function(x) paste0("$", x, "M")) +
      dark_theme +
      theme(legend.position = "none",
            axis.text.y = element_text(color = "#e8eaf0", size = 10))
  }, bg = "#151820")

  # ── Region ──
  output$plot_region <- renderPlot({
    filtered() %>%
      group_by(region, category) %>%
      summarise(revenue = sum(revenue) / 1e6, .groups = "drop") %>%
      ggplot(aes(region, revenue, fill = category)) +
      geom_col(width = 0.55, position = position_dodge(0.65)) +
      scale_fill_manual(values = pal) +
      scale_y_continuous(labels = function(x) paste0("$", x, "M")) +
      dark_theme +
      theme(legend.position = "right")
  }, bg = "#151820")
}

shinyApp(ui, server)
