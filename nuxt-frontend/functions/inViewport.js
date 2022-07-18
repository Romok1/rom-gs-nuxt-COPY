export default function inViewport (element) {
  if (!element) {
    return false
  }

  if (element.nodeType !== 1) {
    return false
  }

  const html = document.documentElement
  const rect = element.getBoundingClientRect()

  return (
    !!rect &&
    rect.bottom >= 0 &&
    rect.right >= 0 &&
    rect.left <= html.clientWidth &&
    rect.top <= html.clientHeight
  )
}
