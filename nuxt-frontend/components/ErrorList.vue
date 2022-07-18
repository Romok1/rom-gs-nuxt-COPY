<template>
  <ul v-if="hasErrors" class="ct-error-list">
    <li
      v-for="(error, errorIndex) in errors"
      :key="errorIndex"
      class="ct-error-list__item"
    >
      {{ error }}
    </li>
  </ul>
</template>

<script>
export default {
  props: {
    errors: {
      type: Array,
      default: () => []
    }
  },

  computed: {
    hasErrors () {
      return this.errors.length > 0
    }
  }
}
</script>

<style lang="postcss" scoped>
.ct-error-list {
  @apply text-red-500
    space-y-4
    p-4
    bg-red-200;
}
</style>
