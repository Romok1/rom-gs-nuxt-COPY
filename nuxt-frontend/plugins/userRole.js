export default ({ app }, inject) => {
  inject('getUserRole', (attribute = 'name') => {
    if (app.$auth.loggedIn) {
      const currentUserRole = app.$auth.$state.user.role

      return currentUserRole[attribute]
    }

    return null
  })
}
