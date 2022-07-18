export default function (to, from, savedPosition) {
  if (savedPosition) {
    return savedPosition
  }
  let position = { x: 0, y: 0 }

  if (to.hash) {
    position = { selector: to.hash }
  } else if (to.matched.some(r => r.components.default.options.scrollToTop === false)) {
    position = {}
  } else if (to.query?.s === '0') {
    // Don't change scroll position when `s` parameter is set to false.
    return {}
  }

  return position
}
