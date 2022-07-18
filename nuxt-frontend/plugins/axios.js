import objectKeysToCamelCase from '~/functions/objectKeysToCamelCase'

const HTTP_UNPROCESSABLE_ENTITY_ERROR = 422
const HTTP_UNAUTHORIZED_ERROR = 401

export default function ({ $axios, $errors, localePath, redirect }) {
  $axios.interceptors.request.use(function (config) {
    if (config.data) {
      $errors.reset()
    }

    return config
  }, function (error) {
    return Promise.reject(error)
  })

  $axios.interceptors.response.use(function (response) {
    // Any status code that lie within the range of 2xx cause this function to trigger
    response.data = objectKeysToCamelCase(response.data)

    return response
  }, function (error) {
    if (error.response.status === HTTP_UNPROCESSABLE_ENTITY_ERROR) {
      $errors.set(error.response.data)
    }
    if (error.response.status === HTTP_UNAUTHORIZED_ERROR && error.config?.url !== '/api/auth/sign_in') {
      return redirect(localePath('/login'))
    }

    // Any status codes that falls outside the range of 2xx cause this function to trigger
    return Promise.reject(error)
  })
}
