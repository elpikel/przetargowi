import Chart from "chart.js/auto"

const COLORS = {
  primary: "#570df8",
  secondary: "#f000b8",
  accent: "#37cdbe",
  warning: "#fbbd23",
  info: "#3abff8",
  success: "#36d399",
  bars: [
    "#570df8", "#f000b8", "#37cdbe", "#fbbd23", "#3abff8",
    "#36d399", "#ff6b6b", "#4ecdc4", "#45b7d1", "#96ceb4"
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
