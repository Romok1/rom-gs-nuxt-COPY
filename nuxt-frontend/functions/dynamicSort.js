/**
 * Sorts numbers and strings by property, asc/desc.
 * @param property Name of the property to sort.
 *                 You can use "-" prefix to sort in descending order.
 *
 * @returns {Function} Sort function.
 */

const dynamicSort = function (property) {
  let sortOrder = 1

  if (property[0] === '-') {
    sortOrder = -1
    property = property.substr(1)
  }

  return function (a, b) {
    /* Next line works with strings and numbers only. */
    const result =
      a[property] < b[property] ? -1 : a[property] > b[property] ? 1 : 0
    return result * sortOrder
  }
}

export default dynamicSort
