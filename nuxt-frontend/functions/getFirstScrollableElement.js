import isScrollable from '~/functions/isScrollable'

/**
 * Get the first element that is scrollable in the element ancestor chain.
 * @param {HTMLElement} ele
 * @returns {HTMLElement} The first element that is scrollable.
 */
export default function getFirstScrollableElement (ele) {
  if (isScrollable(ele)) {
    return ele
  }

  return getFirstScrollableElement(ele.parentElement)
}
