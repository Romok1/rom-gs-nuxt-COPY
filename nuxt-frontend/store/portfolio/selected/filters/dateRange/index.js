export const getters = {
  dateRange: (_state, getters) => {
    return {
      from: getters['from/value'],
      to: getters['to/value']
    }
  }
}

export const actions = {
  store: ({ dispatch }, dateRange) => {
    const {
      from,
      to
    } = dateRange

    dispatch('from/store', from || [])
    dispatch('to/store', to || [])
  }
}
