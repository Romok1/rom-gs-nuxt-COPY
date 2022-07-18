<template>
  <div
    class="
      flex flex-col
      w-full
      min-h-screen
      m-auto
      text-center
      justify-center
      items-center
      space-y-8
    "
  >
    <svg
      xmlns="http://www.w3.org/2000/svg"
      class="fill-red-500"
      width="90"
      height="90"
      viewBox="0 0 48 48"
    >
      <path
        d="M22 30h4v4h-4zm0-16h4v12h-4zm1.99-10C12.94 4 4 12.95 4 24s8.94 20 19.99 20S44 35.05 44 24 35.04 4 23.99 4zM24 40c-8.84 0-16-7.16-16-16S15.16 8 24 8s16 7.16 16 16-7.16 16-16 16z"
      />
    </svg>

    <div class="text-gray-800 text-xl font-extrabold">
      {{ message }}
    </div>
    <p v-if="statusCode === 404" class="text-sm text-gray-600 font-bold">
      <a v-if="typeof $route === 'undefined'" href="/">Back to home</a>
      <NuxtLink v-else to="/">
        Back to home
      </NuxtLink>
    </p>
  </div>
</template>

<script>
export default {
  name: 'LayoutsError',
  layout: 'error',

  props: {
    error: {
      type: Object,
      default: () => ({})
    }
  },
  computed: {
    statusCode () {
      return this.error.statusCode || 500
    },

    message () {
      return this.error.message || 'An unknown error occurred'
    }
  }
}
</script>
