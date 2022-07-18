import defaultGetters from '~/functions/store/getters'

export const state = () => ({
  users: []
})

export const getters = {
  ...defaultGetters('users')
}

export const mutations = {
  store: (state, users) => {
    state.users = users
  }
}

export const actions = {
  store: ({ commit }, users) => commit('store', users)
}
