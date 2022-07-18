export const state = () => ({
  date: null,
  gefId: null,
  indicatorId: null,
  indicatorTypeId: null
})

export const getters = {
  date: state => state.date,
  gefId: state => state.gefId,
  indicatorId: state => state.indicatorId,
  indicatorTypeId: state => state.indicatorTypeId
}

export const mutations = {
  date: (state, date) => (state.date = date),
  gefId: (state, gefId) => (state.gefId = gefId),
  indicatorId: (state, indicatorId) => (state.indicatorId = indicatorId),
  indicatorTypeId: (state, indicatorTypeId) => (state.indicatorTypeId = indicatorTypeId)
}

export const actions = {
  date: ({ commit }, date) => commit('date', date),
  gefId: ({ commit }, gefId) => commit('gefId', gefId),
  indicatorId: ({ commit }, indicatorId) => commit('indicatorId', indicatorId),
  indicatorTypeId: ({ commit }, indicatorTypeId) => commit('indicatorTypeId', indicatorTypeId)
}
