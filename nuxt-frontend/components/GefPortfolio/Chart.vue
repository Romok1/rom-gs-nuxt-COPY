<template>
  <div class="ct-chart">
    <ClientOnly>
      <BarChart
        :key="incrementKey"
        :data="chartState.data"
        :options="chartState.options"
      />
    </ClientOnly>
  </div>
</template>

<script>
export default {
  data () {
    return {
      incrementKey: 0
    }
  },

  computed: {
    annotationValues () {
      // array of const expected value for each year to create the horizontal annotation line in chartjs
      return this.chartData.years.map((year) => { return this.chartData.expected })
    },

    chartData () {
      return this.$store.getters['portfolio/chart/chartData']
    },

    chartState () {
      return {
        data: {
          labels: this.chartData.years,
          datasets: [
            {
              label: this.$t('components.gefPortfolio.chart.labels.yleft'),
              yAxisID: 'A',
              borderColor: 'rgb(255, 99, 132)',
              backgroundColor: 'rgba(255, 99, 132, 0.2)',
              data: this.chartData.projectsAssessed
            },
            {
              label: this.$t('components.gefPortfolio.chart.labels.yright'),
              yAxisID: 'B',
              type: 'line',
              fill: false,
              borderColor: 'rgb(54, 162, 235)',
              data: this.chartData.indicatorValues
            },
            {
              label: this.$t('components.gefPortfolio.chart.labels.annotation'),
              yAxisID: 'B',
              type: 'line',
              fill: false,
              borderDash: [7, 5],
              borderColor: 'rgb(60,179,113)',
              data: this.annotationValues
            }
          ]
        },

        options: {
          scales: {
            xAxes: [{
              gridLines: {
                drawOnChartArea: false
              }
            }],
            yAxes: [
              {
                id: 'A',
                type: 'linear',
                position: 'left',
                gridLines: {
                  drawOnChartArea: false
                }
              },
              {
                id: 'B',
                type: 'linear',
                position: 'right',
                gridLines: {
                  drawOnChartArea: false
                },
                grace: this.chartData.expected
              }
            ]
          }
        }
      }
    }
  },

  watch: {
    chartData () {
      this.incrementKey++
    }
  }
}
</script>
