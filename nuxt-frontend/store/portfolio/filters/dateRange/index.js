export const getters = {
  dateRange: (_state, getters) => {
    return {
      from: getters['from/all'],
      to: getters['to/all']
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
  },

  async initialize ({ dispatch }, { focalAreas, georegions, users, indicatorId }) {
    const params = {
      focal_area_ids: focalAreas,
      georegion_ids: georegions,
      user_ids: users,
      indicator_id: indicatorId
    }

    const dateRange = await this.$axios.$get('/api/portfolio/date_ranges', {
      params
    })

    await dispatch('store', {
      from: dateRange,
      to: dateRange
    })
  }
}
