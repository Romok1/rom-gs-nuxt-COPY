import { snakeCase } from 'lodash'

const objectKeysToSnakeCase = function (input) {
  if (typeof input !== 'object' || input === null) {
    return input
  }

  if (Array.isArray(input)) {
    return input.map(objectKeysToSnakeCase)
  }

  return Object.keys(input).reduce(function (newObject, key) {
    const value = input[key]
    const newValue = (typeof value === 'object') && value !== null ? objectKeysToSnakeCase(value) : value

    if (key.startsWith('_')) {
      // This edge-case is for keys like "_destroy" that must be sent over with "_".
      newObject['_' + snakeCase(key)] = newValue
    } else {
      newObject[snakeCase(key)] = newValue
    }

    return newObject
  }, {})
}

export default objectKeysToSnakeCase
