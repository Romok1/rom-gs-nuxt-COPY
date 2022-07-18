import defaultGetters from '~/functions/store/getters'

export const state = () => ({
  focalAreas: []
})

export const getters = {
  ...defaultGetters('focalAreas')
}

export const mutations = {
  store: (state, focalAreas) => {
    state.focalAreas = focalAreas
  }
}

export const actions = {
  async initialize ({ commit }, { $axios }) {
    const focalAreas = await $axios.$get('/api/portfolio/focal_areas')

    commit('store', focalAreas)
  }
}
