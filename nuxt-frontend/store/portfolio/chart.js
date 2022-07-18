export const state = () => ({
  id: null,
  chartData: null,
  filteredGefIds: null,
  percentageProgress: [],
  geojson: {},
  geojsonPolygons: {}
})

export const getters = {
  id: state => state.id,
  chartData: state => state.chartData,
  filteredGefIds: state => state.filteredGefIds,
  percentageProgress: state => state.percentageProgress,
  geojson: state => state.geojson,
  geojsonPolygons: state => state.geojsonPolygons
}

export const mutations = {
  id: (state, id) => (state.id = id),
  chartData: (state, chartData) => (state.chartData = chartData),
  filteredGefIds: (state, filteredGefIds) => (state.filteredGefIds = filteredGefIds),
  percentageProgress: (state, percentageProgress) => (state.percentageProgress = percentageProgress),
  geojson: (state, geojson) => (state.geojson = geojson),
  geojsonPolygons: (state, geojsonPolygons) => (state.geojsonPolygons = geojsonPolygons)
}

export const actions = {
  id: ({ commit }, id) => commit('id', id),
  chartData: ({ commit }, chartData) => commit('chartData', chartData),
  filteredGefIds: ({ commit }, filteredGefIds) => commit('filteredGefIds', filteredGefIds),
  percentageProgress: ({ commit }, percentageProgress) => commit('percentageProgress', percentageProgress),
  geojson: ({ commit }, geojson) => commit('geojson', geojson),
  geojsonPolygons: ({ commit }, geojsonPolygons) => commit('geojsonPolygons', geojsonPolygons),
  async initialize ({ commit }, { focalAreas, georegions, users, indicatorId, dateRange }) {
    dateRange = dateRange || {}
    const params = {
      focal_area_ids: focalAreas,
      georegion_ids: georegions,
      user_ids: users,
      date_range: [
        dateRange.from,
        dateRange.to
      ].filter(value => value)
    }

    const apiEndpoint = `/api/charts/${indicatorId}`

    const {
      indicatorSummary: {
        id,
        chartData,
        filteredGefIds,
        percentageProgress
      },
      geojson,
      geojsonPolygons
    } = await this.$axios.$get(apiEndpoint, { params })

    commit('id', id)
    commit('chartData', chartData)
    commit('filteredGefIds', filteredGefIds)
    commit('percentageProgress', percentageProgress)
    commit('geojson', geojson)
    commit('geojsonPolygons', geojsonPolygons)
  }
}
