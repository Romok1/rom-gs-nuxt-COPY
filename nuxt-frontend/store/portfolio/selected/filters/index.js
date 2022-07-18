export const getters = {
  filters: (_state, getters) => {
    return {
      focalAreas: getters['focalAreas/all'],
      georegions: getters['georegions/all'],
      users: getters['users/all'],
      dateRange: getters['dateRange/dateRange']
    }
  }
}

export const actions = {
  store: ({ dispatch }, filters) => {
    const {
      focalAreas,
      georegions,
      users,
      dateRange: {
        from,
        to
      }
    } = filters

    dispatch('focalAreas/store', focalAreas || [])
    dispatch('georegions/store', georegions || [])
    dispatch('users/store', users || [])
    dispatch('dateRange/store', {
      from: from || [],
      to: to || []
    })
  }
}
