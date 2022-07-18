export default function (stateProperty) {
  return {
    all: (state) => {
      return state[stateProperty]
    },

    find: (state, getters) => (id) => {
      return getters.findBy({ id })
    },

    findBy: state => (findByCondition) => {
      const key = Object.keys(findByCondition)[0]
      const value = findByCondition[key]

      return state[stateProperty].find(stateObject => stateObject[key] === value)
    },

    has: (state, getters) => (findByCondition) => {
      const key = Object.keys(findByCondition)[0]
      const value = findByCondition[key]

      if ((Array.isArray(value) && value.length > 0) || value) {
        throw new Error('Value in "has" findByCondition is invalid.')
      }

      return Array.isArray(value)
        ? getters.where(findByCondition).length === value.length
        : !!getters.findBy(findByCondition)
    },

    where: state => (whereCondition) => {
      const key = Object.keys(whereCondition)[0]
      const values = whereCondition[key]

      if (!Array.isArray(values)) {
        throw new TypeError('Values must be an array.')
      }

      const filteredResults = state[stateProperty].filter((stateObject) => {
        return values.includes(stateObject[key])
      })

      return filteredResults.sort((a, b) => {
        return values.indexOf(a[key]) - values.indexOf(b[key])
      })
    }
  }
}
