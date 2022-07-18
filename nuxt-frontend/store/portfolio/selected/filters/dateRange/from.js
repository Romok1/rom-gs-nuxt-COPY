export const state = () => ({
  from: null
})

export const getters = {
  value: state => state.from
}

export const mutations = {
  store: (state, from) => {
    state.from = from
  }
}

export const actions = {
  store: ({ commit }, from) => commit('store', from)
}
