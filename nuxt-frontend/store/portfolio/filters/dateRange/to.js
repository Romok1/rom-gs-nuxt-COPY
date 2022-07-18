import defaultGetters from '~/functions/store/getters'

export const state = () => ({
  to: []
})

export const getters = {
  ...defaultGetters('to')
}

export const mutations = {
  store: (state, to) => {
    state.to = to
  }
}

export const actions = {
  store ({ commit }, to) {
    commit('store', to)
  }
}
