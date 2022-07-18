export const state = () => ({
  gefIds: [],
  indicatorTypes: [],
  indicators: []
})

export const getters = {
  gefIds: state => state.gefIds,
  indicatorTypes: state => state.indicatorTypes,
  indicators: state => state.indicators
}

export const mutations = {
  gefIds: (state, gefIds) => {
    state.gefIds = gefIds
  },
  indicatorTypes: (state, indicatorTypes) => {
    state.indicatorTypes = indicatorTypes
  },
  indicators: (state, indicators) => {
    state.indicators = indicators
  }
}

export const actions = {
  gefIds: ({ commit }, gefIds) => commit('gefIds', gefIds),
  indicatorTypes: ({ commit }, indicatorTypes) => commit('indicatorTypes', indicatorTypes),
  indicators: ({ commit }, indicators) => commit('indicators', indicators),

  async initialize ({ commit, dispatch, rootGetters }, { $axios }) {
    const {
      gefIds,
      indicatorTypes,
      indicators
    } = await $axios.$get('/api/portfolios')

    commit('gefIds', gefIds)
    commit('indicatorTypes', indicatorTypes)
    commit('indicators', indicators)

    const indicatorTypeIndicatorFirst = indicators.find(indicator => indicator.indicatorTypeId === indicatorTypes[0].id)

    commit('selected/indicatorTypeId', indicatorTypes[0].id)
    commit('selected/indicatorId', indicatorTypeIndicatorFirst.id)

    const {
      focalAreas,
      georegions,
      users
    } = rootGetters['portfolio/selected/filters/filters']
    const indicatorId = rootGetters['portfolio/selected/indicatorId']

    const chartPromise = dispatch.call({ $axios }, 'chart/initialize', {
      focalAreas,
      georegions,
      users,
      indicatorId
    })
    const dateRangePromise = dispatch.call({ $axios }, 'filters/dateRange/initialize', {
      focalAreas,
      georegions,
      users,
      indicatorId
    })

    await Promise.all([
      chartPromise,
      dateRangePromise
    ])
  }
}
