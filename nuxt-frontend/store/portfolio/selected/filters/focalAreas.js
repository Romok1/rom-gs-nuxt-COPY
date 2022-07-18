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
  store: ({ commit }, focalAreas) => commit('store', focalAreas)
}
