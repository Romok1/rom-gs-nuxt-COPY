// @see https://htmldom.dev/check-if-an-element-is-scrollable/
export default function isScrollable (ele) {
  // Compare the height to see if the element has scrollable content
  const hasScrollableContent = ele.scrollHeight > ele.clientHeight

  // It's not enough because the element's `overflow-y` style can be set as
  // * `hidden`
  // * `hidden !important`
  // In those cases, the scrollbar isn't shown
  const overflowYStyle = window.getComputedStyle(ele).overflowY
  const isOverflowHidden = overflowYStyle.includes('hidden')

  return hasScrollableContent && !isOverflowHidden
}
