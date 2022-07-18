import Vue from 'vue'
// @TODO: add "actioncable-vue": "~2.5.1" to package.json when intending to use feature again.
import ActionCableVue from 'actioncable-vue'

export default function (context) {
  Vue.use(ActionCableVue, {
    debug: true,
    debugLevel: 'all',
    connectionUrl () {
      const token = window.localStorage.getItem('auth._token.local')

      return `${context.$config.websocketHost}?token=${token.replace('Bearer ', '')}`
    },
    connectImmediately: false
  })
}
