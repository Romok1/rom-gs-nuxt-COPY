import defaultGetters from '~/functions/store/getters'

export const state = () => ({
  georegions: []
})

export const getters = {
  ...defaultGetters('georegions')
}

export const mutations = {
  store: (state, georegions) => {
    state.georegions = georegions
  }
}

export const actions = {
  store: ({ commit }, georegions) => {
    commit('store', georegions)
  }
}
