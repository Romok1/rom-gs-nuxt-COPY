
export default {
  // @see https://nuxtjs.org/docs/configuration-glossary/configuration-server/
  server: {
    host: process.env.HOST || 'localhost',
    port: process.env.PORT || 8080
  },

  // Global page headers: https://go.nuxtjs.dev/config-head
  head: {
    title: process.env.APP_TITLE,
    meta: [
      { charset: 'utf-8' },
      { name: 'viewport', content: 'width=device-width, initial-scale=1' },
      { hid: 'description', name: 'description', content: process.env.APP_DESCRIPTION },
      { name: 'format-detection', content: 'telephone=no' }
    ],
    link: [
      { rel: 'icon', type: 'image/x-icon', href: '/favicon.ico' }
    ]
  },

  // Global CSS: https://go.nuxtjs.dev/config-css
  css: [],

  // Plugins to run before rendering page: https://go.nuxtjs.dev/config-plugins
  plugins: [
    { src: '~/plugins/vueTailwind.js' },
    { src: '~/plugins/errors.js' },
    { src: '~/plugins/axios.js' },
    { src: '~/plugins/userRole.js' },
    { src: '~/plugins/scrollPosition.js', mode: 'client' },
    { src: '~/plugins/scrollTo.js', mode: 'client' },
    { src: '~/plugins/mapbox.js', mode: 'client' },
    { src: '~/plugins/vueChart.js', mode: 'client' }
  ],

  // Auto import components: https://go.nuxtjs.dev/config-components
  components: true,

  // Modules for dev and build (recommended): https://go.nuxtjs.dev/config-modules
  buildModules: [
    // https://go.nuxtjs.dev/eslint
    '@nuxtjs/eslint-module',
    // https://go.nuxtjs.dev/stylelint
    '@nuxtjs/stylelint-module'
  ],

  // Modules: https://go.nuxtjs.dev/config-modules
  modules: [
    // https://i18n.nuxtjs.org/
    // https://github.com/nuxt-community/i18n-module
    '@nuxtjs/i18n',
    // https://go.nuxtjs.dev/axios
    '@nuxtjs/axios',
    // https://go.nuxtjs.dev/pwa
    '@nuxtjs/pwa',
    // https://dev.auth.nuxtjs.org/
    '@nuxtjs/auth-next',
    // https://github.com/LinusBorg/portal-vue
    'portal-vue/nuxt',
    // https://content.nuxtjs.org/
    '@nuxt/content',
    // https://tailwindcss.nuxtjs.org/
    '@nuxtjs/tailwindcss'
  ],

  // Internationalisation (https://i18n.nuxtjs.org)
  i18n: {
    locales: [
      {
        code: 'en',
        name: 'English',
        iso: 'en',
        file: 'en.js'
      }
    ],
    defaultLocale: 'en',
    strategy: 'prefix',
    lazy: true,
    langDir: 'lang/',
    seo: true,
    baseUrl: ({ $config: { baseUrl } }) => baseUrl,
    detectBrowserLanguage: {
      useCookie: true,
      cookieKey: 'i18n_redirected',
      onlyOnRoot: true
    }
  },

  content: {
    // intentionally blank
  },

  auth: {
    plugins: [
      '~/plugins/authRedirect.js'
    ],
    strategies: {
      local: {
        token: {
          property: 'token',
          global: true
        },
        user: {
          autoFetch: false,
          property: 'user'
        },
        endpoints: {
          login: {
            url: '/api/auth/sign_in',
            method: 'post',
            headers: {
              Accept: 'application/json',
              'Content-Type': 'application/json'
            }
          },
          logout: {
            url: '/api/auth/sign_out',
            method: 'delete',
            headers: {
              Accept: 'application/json',
              'Content-Type': 'application/json'
            }
          },
          user: {
            url: '/api/auth/user',
            method: 'get',
            headers: {
              Accept: 'application/json',
              'Content-Type': 'application/json'
            }
          }
        }
      }
    },
    redirect: {
      login: '/login',
      logout: '/login',
      callback: '/login',
      home: '/gef-projects/'
    }
  },

  // Axios module configuration: https://go.nuxtjs.dev/config-axios
  axios: {
    proxy: true,
    headers: {
      common: {
        'Content-Type': 'application/json',
        Accept: 'application/json'
      }
    }
  },

  proxy: {
    '/api/': {
      target: process.env.RAILS_API_ENDPOINT,
      pathRewrite: { '^/api/': '' }
    },
    '/rails/': {
      target: process.env.RAILS_ENDPOINT
    }
  },

  // PWA module configuration: https://go.nuxtjs.dev/pwa
  pwa: {
    manifest: {
      lang: 'en'
    },
    disable: process.env.NODE_ENV === 'development',
    register: true,
    scope: '/',
    dest: 'public',
    swSrc: 'service-worker.js'
  },

  // Build Configuration: https://go.nuxtjs.dev/config-build
  build: {
    postcss: {
      // Add plugin names as key and arguments as value
      // Install them before as dependencies with npm or yarn
      plugins: {
        // Disable a plugin by passing false as value
        'postcss-import': {},
        'tailwindcss/nesting': {},
        autoprefixer: {}
      }
    },
    transpile: [
      '@rails/activestorage'
    ]
  },

  publicRuntimeConfig: {
    mapbox: {
      accessToken: process.env.MAPBOX_ACCESS_TOKEN,
      mapStyle: process.env.MAPBOX_MAP_STYLE
    },
    geoserver: {
      remoteHost: process.env.GEOSERVER_REMOTE_HOST,
      owsEndpoint: process.env.GEOSERVER_OWS_ENDPOINT,
      basicAuth: {
        user: process.env.GEOSERVER_BASIC_AUTH_USER,
        password: process.env.GEOSERVER_BASIC_AUTH_PASSWORD
      }
    },
    railsApiEndpoint: process.env.RAILS_API_ENDPOINT,
    railsEndpoint: process.env.RAILS_ENDPOINT,
    websocketHost: process.env.WEBSOCKET_HOST
  }
}
