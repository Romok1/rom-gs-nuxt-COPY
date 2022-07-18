<template>
  <div class="ct-selector">
    <ul class="ct-selector__list">
      <li
        v-for="option in options"
        :key="option[valueAttribute]"
        class="ct-selector__item"
      >
        <button
          class="ct-selector__button"
          :class="{
            'ct-selector__button--selected': isSelected(option)
          }"
          @click="onButtonClick(option)"
          v-text="option[textAttribute]"
        />
      </li>
    </ul>
  </div>
</template>

<script>
export default {
  model: {
    event: 'change',
    prop: 'value'
  },

  props: {
    value: {
      type: [Number, String],
      required: true
    },

    options: {
      type: Array,
      required: true
    },

    valueAttribute: {
      type: String,
      default: 'id'
    },

    textAttribute: {
      type: String,
      default: 'name'
    }
  },

  methods: {
    onButtonClick (option) {
      this.$emit('change', option[this.valueAttribute])
    },

    isSelected (option) {
      return option[this.valueAttribute] === this.value
    }
  }
}
</script>

<style lang="postcss" scoped>
.ct-selector {
  &__list {
    @apply flex
      space-x-4;
  }

  &__button {
    /**
     * @TODO:
     * @see https://github.com/nuxt-community/tailwindcss-module/issues/415
     *
     * @apply t-button--small;
     */
    @apply
      text-t0
      p-2
      rounded-full
      font-normal;

    &--selected {
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
  }
}
</style>
