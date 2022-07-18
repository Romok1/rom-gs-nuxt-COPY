import { debounce } from 'lodash'
import Vue from 'vue'

const MODULE_NAMESPACE = 'scrollPosition'

const scrollPositionModule = {
  namespaced: true,

  state: () => ({
    position: { x: 0, y: 0 }
  }),

  getters: {
    position: (state) => {
      return state.position
    },

    x: (state) => {
      return state.position.x
    },

    y: (state) => {
      return state.position.y
    }
  },

  mutations: {
    set: (state, scrollPosition) => {
      state.position = scrollPosition
    }
  }
}

/**
 * If ,you don't just want to know your scroll position, but you want to know
 * what it is in (debounced) real-time, use this custom VueX module with
 *  this.$store.getters['scrollPosition/y']
 * to get the scrollY position (x for scrollX position).
 */
export default function ({ store }, inject) {
  store.registerModule(MODULE_NAMESPACE, scrollPositionModule)

  Vue.mixin({
    beforeMount () {
      window.addEventListener('scroll', this.__updateScrollPosition__)
    },

    mounted () {
      this.__updateScrollPosition__()
    },

    beforeDestroy () {
      window.removeEventListener('scroll', this.__updateScrollPosition__)
    },

    methods: {
      __updateScrollPosition__: debounce(function () {
        this.$store.commit(`${MODULE_NAMESPACE}/set`, {
          x: window.scrollX,
          y: window.scrollY
        })
      }, 10)
    }
  })
}
