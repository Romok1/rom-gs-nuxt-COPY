<template>
  <div class="ct-pill-filters">
    <button
      v-for="(option) in options"
      :key="option.value"
      class="ct-pill-filters__button"
      :class="optionClasses(option)"
      @click="onOptionClick(option)"
      v-text="option.label"
    />
  </div>
</template>

<script>
export default {
  model: {
    event: 'change',
    prop: 'value'
  },

  props: {
    options: {
      type: Array,
      required: true
    },

    value: {
      type: [
        Boolean,
        Number,
        String
      ],
      required: true
    }
  },

  methods: {
    isOptionActive (option) {
      return this.value === option.value
    },

    optionClasses (option) {
      return this.isOptionActive(option)
        ? 'ct-pill-filters__button--active'
        : 'ct-pill-filters__button--inactive'
    },

    onOptionClick (option) {
      this.$emit('change', option.value)
    }
  }
}
</script>

<style lang="postcss" scoped>
.ct-pill-filters {
  @apply space-x-2;

  &__button {
    /**
     * @TODO:
     * @see https://github.com/nuxt-community/tailwindcss-module/issues/415
     *
     * @apply t-button t-button--small;
     */
    @apply
      inline-block
      text-t1
      font-bold
      p-3
      border-2
      md:px-14
      rounded-full
      disabled:bg-theme-blueLight
      disabled:border
      disabled:border-theme-blueLight
      disabled:cursor-not-allowed
      disabled:text-theme-gray
      transition
      duration-100
      ease-in-out
      focus:border-blue-600
      focus:outline-none
      focus:ring-2
      focus:ring-blue-600
      focus:ring-opacity-50

      text-t0
      p-2
      font-normal;

    &--active {
      /**
      * @TODO:
      * @see https://github.com/nuxt-community/tailwindcss-module/issues/415
      *
      * @apply t-button--default;
      */
      @apply text-white
        bg-theme-blueDark
        border-white
        hover:bg-theme-blue;
    }

    &--inactive {
      /**
      * @TODO:
      * @see https://github.com/nuxt-community/tailwindcss-module/issues/415
      *
      * @apply t-button--secondary;
      */
      @apply
        text-black
        bg-white
        border-theme-blueDark
        hover:text-blue-400;
    }
  }
}
</style>
