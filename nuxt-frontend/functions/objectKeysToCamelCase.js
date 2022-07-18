import { camelCase } from 'lodash'

const objectKeysToCamelCase = function (input) {
  if (typeof input !== 'object' || input === null) {
    return input
  }

  if (Array.isArray(input)) {
    return input.map(objectKeysToCamelCase)
  }

  return Object.keys(input).reduce(function (newObject, key) {
    const value = input[key]
    const newValue = (typeof value === 'object') && value !== null ? objectKeysToCamelCase(value) : value

    newObject[camelCase(key)] = newValue

    return newObject
  }, {})
}

export default objectKeysToCamelCase
