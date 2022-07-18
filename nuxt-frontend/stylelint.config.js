module.exports = {
  customSyntax: 'postcss-html',
  extends: [
    'stylelint-config-standard',
    'stylelint-config-standard-vue',
    'stylelint-config-tailwindcss'
  ],
  plugins: [
    '@namics/stylelint-bem'
  ],
  // add your custom config here
  // https://stylelint.io/user-guide/configuration
  rules: {
    'plugin/stylelint-bem-namics': {
      namespaces: [
        'ct-',
        'nuxt-link-'
      ],
      patternPrefixes: [],
      helperPrefixes: []
    },
    'selector-class-pattern': null,
    'selector-pseudo-class-no-unknown': [
      true,
      {
        ignorePseudoClasses: [
          'deep'
        ]
      }
    ]
  }
}
