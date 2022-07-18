import getFirstScrollableElement from '~/functions/getFirstScrollableElement'

export default function (context, inject) {
  inject('scrollTo', (el, offset = 0) => {
    getFirstScrollableElement(el).scrollTo({
      top: el.offsetTop - offset,
      behavior: 'smooth'
    })
  })
}
