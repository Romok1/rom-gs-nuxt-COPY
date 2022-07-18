export default ({ $auth, localePath }) => {
  $auth.onRedirect((to) => {
    return localePath(to)
  })
}
