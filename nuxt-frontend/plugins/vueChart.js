/* eslint-disable import/no-extraneous-dependencies */
import Vue from 'vue'
import { Bar } from 'vue-chartjs'

Vue.component('BarChart', {
  extends: Bar,

  props: {
    data: {
      type: Object,
      default: () => {}
    },
    options: {
      type: Object,
      default: () => {}
    }
  },

  mounted () {
    this.renderChart(this.data, this.options)
  }
})
