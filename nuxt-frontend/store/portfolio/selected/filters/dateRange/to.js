export const state = () => ({
  to: null
})

export const getters = {
  value: state => state.to
}

export const mutations = {
  store: (state, to) => {
    state.to = to
  }
}

export const actions = {
  store: ({ commit }, to) => commit('store', to)
}
