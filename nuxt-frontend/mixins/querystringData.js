/**
 * Use this mixin to boot up a reactive querystring parameter.
 * Use in conjunction with router.scrollBehavior.js to use a querystring param
 * equal to `s=0` to prevent jarring scroll behaviour when state changes.
 *
 * Use beforeMount() to set a default value for `dataProp`.
 * Also use `key: to => to.fullPath,` and `watchQuery: [<dataProp>],`.
 *
 * @author Jonathan Feist
 */
export default (configuration = {}) => {
  /**
   * @param {string} dataProp The data property to create.
   * @param {boolean} multiple Whether to use multiple values mode.
   * @param {string} optionsProp The data to use for the options.
   * @param {string} optionIdentifier The acting prop in the options object to be id.
   */
  const {
    dataProp,
    multiple,
    optionsProp,
    optionIdentifier
  } = { multiple: false, ...configuration }

  return {
    computed: {
      [dataProp]: {
        get () {
          const routeQuery = this.$route.query[dataProp]

          if (multiple) {
            // `[].concat()` is used to wrap the value in an array by default.
            const values = [].concat(routeQuery).filter(value => value).map(
              value => optionFinder.call(this, { optionsProp, optionIdentifier, value })
            ).filter(value => value)

            return values
          }

          return optionFinder.call(this, { optionsProp, optionIdentifier, value: routeQuery })
        },
        set (setValue) {
          if (multiple) {
            // `[].concat()` is used to wrap the value in an array by default.
            setValue = [].concat(setValue).filter(value => value).map(
              value => optionFinder.call(this, { optionsProp, optionIdentifier, value })
            ).filter(value => value)
          } else {
            setValue = optionFinder.call(this, { optionsProp, optionIdentifier, value: setValue })
          }

          this.$router.push({
            query: {
              ...this.$route.query,
              // @see https://nuxtjs.org/docs/configuration-glossary/configuration-router/#scrollbehavior
              s: 0, // Used by app/router.scrollBehavior.js to prevent scrolling.
              [dataProp]: setValue
            }
          })
        }
      }
    }
  }
}

const optionFinder = function ({ optionsProp, optionIdentifier, value }) {
  try {
    const foundObject = this[optionsProp].find(option => option[optionIdentifier] === value)

    return foundObject[optionIdentifier]
  } catch (e) {
    return undefined
  }
}
