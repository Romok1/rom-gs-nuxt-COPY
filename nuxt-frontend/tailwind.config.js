/** @type {import('tailwindcss').Config} */

const colors = require('tailwindcss/colors')
const themeScreens = require('./tailwind/breakpoints.config.js')
const themeColors = require('./tailwind/colors.config.js')

module.exports = {
  content: [
    './app.html',
    './components/**/*.{vue,js}',
    './content/**/*.md',
    './layouts/**/*.vue',
    './pages/**/*.vue',
    './plugins/**/*.{js,ts}',
    './nuxt.config.{js,ts}'
  ],
  theme: {
    fontFamily: {
      sans: ['Roboto', 'sans-serif', 'ui-sans-serif', 'system-ui'],
      serif: ['Roboto Serif', 'ui-serif', 'Georgia'],
      mono: ['Roboto Mono', 'ui-monospace', 'SFMono-Regular'],
      display: ['Roboto', 'sans-serif', 'ui-sans-serif', 'system-ui'],
      body: ['Roboto', 'sans-serif', 'ui-sans-serif', 'system-ui']
    },
    extend: {
      fontSize: {
        t0: ['14px', '17px'],
        t1: ['20px', '26px'],
        s1: ['16px', '19px'],
        subtext: ['18px', '24px'],
        h1: ['36px', '44px'],
        h2: ['32px', '42px'],
        h3: ['30px', '38px'],
        h4: ['28px', '36px'],
        h5: ['27px', '34px'],
        h6: ['26px', '32px']
      },
      colors: {
        theme: themeColors,
        gray: colors.neutral,
        green: colors.emerald,
        purple: colors.violet,
        yellow: colors.amber
      }
    },
    plugins: [],
    screens: themeScreens
  }
}
