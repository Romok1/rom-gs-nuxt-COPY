import defaultGetters from '~/functions/store/getters'

export const state = () => ({
  from: []
})

export const getters = {
  ...defaultGetters('from')
}

export const mutations = {
  store: (state, from) => {
    state.from = from
  }
}

export const actions = {
  store ({ commit }, from) {
    commit('store', from)
  }
}
