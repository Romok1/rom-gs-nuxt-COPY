const MODULE_NAMESPACE = 'errors'

const validErrorMessages = function (errorMessages) {
  return Array.isArray(errorMessages) &&
    errorMessages.every(message => typeof message === 'string')
}

const validErrorBag = function (errorBag) {
  if (typeof errorBag === 'object' && errorBag !== null) {
    return Object.keys(errorBag).every(key => validErrorMessages(errorBag[key]))
  }

  return false
}

const errorsModule = {
  namespaced: true,

  state: () => ({
    errorBag: {}
  }),

  getters: {
    errorBag: (state) => {
      return state.errorBag
    },

    any: (_state, getters) => (field) => {
      return getters.has(field)
    },

    anyStartsWith: state => (path) => {
      return Object.keys(state.errorBag).some(key => key.startsWith(path))
    },

    count: state => (field) => {
      if (Object.keys(state.errorBag).length > 0) {
        if (field) {
          return Object.prototype.hasOwnProperty.call(state.errorBag, field)
            ? state.errorBag[field].length
            : 0
        }

        return Object.values(state.errorBag).reduce((carr, curr) => carr + curr.length, 0)
      }

      return 0
    },

    first: (_state, getters) => (field) => {
      return getters.has(field) ? getters.get(field)[0] : undefined
    },

    get: (_state, getters) => (field) => {
      if (getters.has(field)) {
        return getters.errorBag[field]
      }

      return []
    },

    has: (_state, getters) => (field) => {
      return getters.count(field) > 0
    }
  },

  mutations: {
    add: (state, { field, errorMessages }) => {
      if (!validErrorMessages(errorMessages)) {
        throw new TypeError('The errorMessages must be an array of error messages.')
      }

      state.errorBag[field] = [...(state.errorBag[field] || []), ...errorMessages]
    },

    set: (state, errorBag) => {
      if (!validErrorBag(errorBag)) {
        throw new TypeError('The errorBag must be an object whose keys should be arrays of error messages.')
      }

      state.errorBag = errorBag
    },

    merge: (state, errorBag) => {
      if (!validErrorBag(errorBag)) {
        throw new TypeError('The errorBag must be an object whose keys should be arrays of error messages.')
      }

      state.errorBag = {
        ...state.errorBag,
        ...errorBag
      }
    },

    clear: (state, field) => {
      delete state.errorBag[field]
    },

    reset: (state) => {
      state.errorBag = {}
    }
  },

  actions: {
    add: ({ commit }, payload) => {
      commit('add', payload)
    },

    set: ({ commit }, payload) => {
      commit('set', payload)
    },

    merge: ({ commit }, payload) => {
      commit('merge', payload)
    },

    clear: ({ commit }, payload) => {
      commit('clear', payload)
    },

    reset: ({ commit }, payload) => {
      commit('reset', payload)
    }
  }
}

export default function ({ store }, inject) {
  store.registerModule(MODULE_NAMESPACE, errorsModule)

  inject(MODULE_NAMESPACE, {
    errorBag: () => store.getters[`${MODULE_NAMESPACE}/errorBag`],
    any: field => store.getters[`${MODULE_NAMESPACE}/any`](field),
    anyStartsWith: field => store.getters[`${MODULE_NAMESPACE}/anyStartsWith`](field),
    count: field => store.getters[`${MODULE_NAMESPACE}/count`](field),
    first: field => store.getters[`${MODULE_NAMESPACE}/first`](field),
    get: field => store.getters[`${MODULE_NAMESPACE}/get`](field),
    has: field => store.getters[`${MODULE_NAMESPACE}/has`](field),
    add: payload => store.dispatch(`${MODULE_NAMESPACE}/add`, payload),
    set: payload => store.dispatch(`${MODULE_NAMESPACE}/set`, payload),
    merge: payload => store.dispatch(`${MODULE_NAMESPACE}/merge`, payload),
    clear: payload => store.dispatch(`${MODULE_NAMESPACE}/clear`, payload),
    reset: payload => store.dispatch(`${MODULE_NAMESPACE}/reset`, payload)
  })
}
