// Avoids: [vuex] do not mutate vuex store state outside mutation handlers.
export const duplicate = (value) => {
  const wrappedValue = [].concat(value)

  return wrappedValue[0]
}
