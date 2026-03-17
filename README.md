# 📊 Sales Analytics Dashboard — R Shiny

A dark-themed sales analytics dashboard built with Shiny + ggplot2.

## Features
- KPI cards (Revenue, Orders, AOV)
- Revenue trend line chart
- Category breakdown bar chart
- Region × Category grouped bar chart
- Sidebar filters: year range, region, category

---

## 🚀 Deployment Guide

### Option A — shinyapps.io via GitHub Actions (recommended)

**Step 1 — Push to GitHub**
```bash
git init
git add .
git commit -m "Initial commit"
git remote add origin https://github.com/YOUR_USER/YOUR_REPO.git
git push -u origin main
```

**Step 2 — Get shinyapps.io credentials**

1. Sign up / log in at https://www.shinyapps.io
2. Go to **Account → Tokens → Add Token**
3. Click **Show** and copy the three values:
   - Account name
   - Token
   - Secret

**Step 3 — Add GitHub Secrets**

In your GitHub repo go to **Settings → Secrets and variables → Actions → New repository secret** and add:

| Secret name          | Value                    |
|----------------------|--------------------------|
| `SHINYAPPS_ACCOUNT`  | your shinyapps.io account name |
| `SHINYAPPS_TOKEN`    | token from step 2        |
| `SHINYAPPS_SECRET`   | secret from step 2       |

**Step 4 — Push any change to `main`**

The workflow in `.github/workflows/deploy.yml` will automatically install R packages and deploy the app. Check progress under the **Actions** tab.

Your app will be live at:
```
https://YOUR_ACCOUNT.shinyapps.io/sales-dashboard/
```

---

### Option B — Shinylive (static, no server needed)

Deploy as a fully static site on **GitHub Pages**. No shinyapps.io account required.

```r
install.packages("shinylive")
shinylive::export(".", "docs")   # run from repo root
```

Then commit the `docs/` folder, push, and enable GitHub Pages:

**Settings → Pages → Source: Deploy from branch → Branch: main, Folder: /docs**

Your app will be at `https://YOUR_USER.github.io/YOUR_REPO/`

> ⚠️ Shinylive runs R in the browser via WebAssembly. All packages must be available in the Shinylive package repository. `shiny`, `ggplot2`, and `dplyr` are all supported.

---

### Option C — Run locally

```r
install.packages(c("shiny", "ggplot2", "dplyr"))
shiny::runApp(".")
```

---

## File Structure

```
.
├── app.R                          # Shiny application
├── requirements.txt               # R package list
├── README.md
└── .github/
    └── workflows/
        └── deploy.yml             # Auto-deploy to shinyapps.io
```
