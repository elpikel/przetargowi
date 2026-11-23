import Chart from "chart.js/auto"

// One accent hue plus neutrals, matching the rest of the site
const COLORS = {
  primary: "#2347d9",
  secondary: "#0f172a",
  accent: "#5a78e6",
  warning: "#b45309",
  info: "#7c93ec",
  success: "#15803d",
  bars: [
    "#2347d9", "#3b5fe0", "#5a78e6", "#7c93ec", "#9fb0f2",
    "#0f172a", "#334155", "#64748b", "#94a3b8", "#cbd5e1"
  ]
}

const MarketCharts = {
  charts: {},

  mounted() {
    this.handleEvent("chart-data", ({analysis}) => {
      this.destroyAll()
      this.renderContractorsChart(analysis.top_contractors)
      this.renderTrendsChart(analysis.trends)
      this.renderCriteriaChart(analysis.criteria)
      if (analysis.price_distribution.count > 0) {
        this.renderPriceChart(analysis.price_distribution)
      }
    })
  },

  destroyed() {
    this.destroyAll()
  },

  destroyAll() {
    Object.values(this.charts).forEach(c => c.destroy())
    this.charts = {}
  },

  renderPriceChart(data) {
    const ctx = document.getElementById("price-chart")
    if (!ctx || !data.buckets.length) return

    this.charts.price = new Chart(ctx, {
      type: "bar",
      data: {
        labels: data.labels,
        datasets: [{
          label: "Liczba kontraktów",
          data: data.buckets,
          backgroundColor: COLORS.primary + "cc",
          borderColor: COLORS.primary,
          borderWidth: 1,
          borderRadius: 4
        }]
      },
      options: {
        responsive: true,
        plugins: { legend: { display: false } },
        scales: {
          x: { ticks: { maxRotation: 45 } },
          y: { beginAtZero: true, ticks: { stepSize: 1 } }
        }
      }
    })
  },

  renderContractorsChart(data) {
    const ctx = document.getElementById("contractors-chart")
    if (!ctx || !data.length) return

    const top = data.slice(0, 8)

    this.charts.contractors = new Chart(ctx, {
      type: "bar",
      data: {
        labels: top.map(c => c.name.length > 35 ? c.name.substring(0, 35) + "..." : c.name),
        datasets: [{
          label: "Wygrane kontrakty",
          data: top.map(c => c.wins),
          backgroundColor: COLORS.bars.slice(0, 8).map(c => c + "cc"),
          borderColor: COLORS.bars.slice(0, 8),
          borderWidth: 1,
          borderRadius: 4
        }]
      },
      options: {
        indexAxis: "y",
        responsive: true,
        plugins: { legend: { display: false } },
        scales: {
          x: { beginAtZero: true, ticks: { stepSize: 1 } }
        }
      }
    })
  },

  renderTrendsChart(data) {
    const ctx = document.getElementById("trends-chart")
    if (!ctx || !data.length) return

    this.charts.trends = new Chart(ctx, {
      type: "line",
      data: {
        labels: data.map(t => t.month),
        datasets: [{
          label: "Postępowań",
          data: data.map(t => t.count),
          borderColor: COLORS.primary,
          backgroundColor: COLORS.primary + "33",
          fill: true,
          tension: 0.3,
          pointRadius: 4,
          pointHoverRadius: 6
        }]
      },
      options: {
        responsive: true,
        plugins: { legend: { display: false } },
        scales: {
          y: { beginAtZero: true, ticks: { stepSize: 1 } }
        }
      }
    })
  },

  renderCriteriaChart(data) {
    const ctx = document.getElementById("criteria-chart")
    if (!ctx || !data.top_criteria || !data.top_criteria.length) return

    const top = data.top_criteria.slice(0, 6)

    this.charts.criteria = new Chart(ctx, {
      type: "doughnut",
      data: {
        labels: top.map(k => k.name),
        datasets: [{
          data: top.map(k => k.count),
          backgroundColor: COLORS.bars.slice(0, 6).map(c => c + "cc"),
          borderColor: COLORS.bars.slice(0, 6),
          borderWidth: 1
        }]
      },
      options: {
        responsive: true,
        plugins: {
          legend: {
            position: "right",
            labels: { font: { size: 12 } }
          }
        }
      }
    })
  }
}

export default MarketCharts
