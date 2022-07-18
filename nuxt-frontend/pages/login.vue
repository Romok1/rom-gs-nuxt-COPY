<template>
  <div class="w-full my-4">
    <div class="mx-auto sm:max-w-md bg-white p-4 sm:p-8 sm:rounded-sm sm:shadow-md">
      <form @submit.prevent="onSubmit">
        <TInputGroup
          label="Email"
          class="mb-4 md:mb-6"
          v-bind="{ variant: inputVariant }"
        >
          <TInput
            v-model="login.email"
            v-bind="{ variant: inputVariant }"
            type="text"
          />
        </TInputGroup>
        <TInputGroup
          class="mb-4 md:mb-6"
          label="Password"
          v-bind="{ variant: inputVariant }"
        >
          <TInput
            v-model="login.password"
            v-bind="{ variant: inputVariant }"
            type="password"
          />
        </TInputGroup>
        <div class="mt-10 flex justify-center">
          <TButton
            type="submit"
            v-bind="{ variant: inputVariant }"
            v-text="$t('common.login')"
          />
        </div>
      </form>
    </div>
  </div>
</template>

<script>
export default {
  name: 'LoginPage',

  auth: 'guest',

  middleware ({ $auth, localePath, redirect }) {
    if ($auth.loggedIn) {
      redirect(localePath('/gef-projects'))
    }
  },

  data () {
    return {
      busy: false,

      login: {
        email: '',
        password: ''
      },

      hasError: false
    }
  },

  computed: {
    inputVariant () {
      return this.hasError ? 'danger' : ''
    }
  },

  methods: {
    async onSubmit () {
      await this.userLogin()
    },

    setBusy (busy) {
      this.busy = busy === true
    },

    setError (hasError) {
      this.hasError = hasError === true
    },

    async userLogin () {
      try {
        this.setBusy(true)
        this.setError(false)
        const response = await this.$auth.loginWith('local', {
          data: {
            v1_user: this.login
          }
        })
        const [, token] = response.headers.authorization.split(' ')

        if (token) {
          this.$auth.setUserToken(token)
          this.$axios.setToken(token)
          this.$auth.setUser(response.data)
        }
      } catch (err) {
        // eslint-disable-next-line
        console.log({ err })

        if (err.response.status === 401) {
          this.setError(true)
        }
      }
      this.setBusy(false)
    }
  }
}
</script>
