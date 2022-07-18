<template>
  <button
    class="ct-button"
    @click="onButtonClick"
  >
    <IconMinus
      v-if="selected"
      class="ct-button__icon"
    />
    <IconPlus
      v-else
      class="ct-button__icon"
    />
  </button>
</template>

<script>
export default {
  model: {
    prop: 'selected',
    event: 'change'
  },

  props: {
    selected: {
      type: Boolean,
      required: true
    }
  },

  methods: {
    onButtonClick () {
      this.$emit('change', !this.selected)
    }
  }
}
</script>

<style lang="postcss" scoped>
.ct-button {
  @apply p-2;

  &__icon {
    @apply rounded-full
      border
      border-theme-blue
      text-theme-blue
      w-11
      h-11
      p-2;
  }
}
</style>
