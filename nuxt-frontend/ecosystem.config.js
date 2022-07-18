module.exports = {
  apps: [{
    name: 'gef-spatial',
    script: 'yarn',
    watch: 'true',
    args: 'start',
    cwd: '/home/wcmc/gef-spatial/current/nuxt-frontend',
    interpreter: '/bin/bash',
    env: {
      NODE_PORT: '8282',
      NODE_ENV: 'production'
    }
  }]
}
