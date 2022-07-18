<template>
  <ul class="ct-multiselect">
    <li
      v-for="option in options"
      :key="option.id"
      class="ct-multiselect__option"
      @click.prevent="onSelectButtonClick(option)"
    >
      <div
        class="ct-multiselect__checkbox"
        :class="checkboxClasses(option)"
      />
      <span v-text="option.label" />
    </li>
  </ul>
</template>

<script>
export default {
  model: {
    event: 'change',
    prop: 'ids'
  },

  props: {
    ids: {
      type: Array,
      default: () => []
    },

    options: {
      type: Array,
      required: true
    }
  },

  methods: {
    checkboxClasses (option) {
      return [
        this.isValueSelected(option.id)
          ? 'ct-multiselect__checkbox--selected'
          : 'ct-multiselect__checkbox--unselected'
      ]
    },

    isValueSelected (id) {
      return this.ids.includes(id)
    },

    onSelectButtonClick (option) {
      if (this.isValueSelected(option.id)) {
        this.$emit(
          'change',
          this.ids.filter(id => id !== option.id)
        )
      } else {
        this.$emit('change', this.ids.concat([option.id]))
      }
    }
  }
}
</script>

<style lang="postcss" scoped>
.ct-multiselect {
  @apply space-y-2;

  &__option {
    @apply cursor-pointer
      flex
      flex-nowrap
      items-center;
  }

  &__checkbox {
    @apply w-4
      h-4
      border border-neutral-500
      mr-2
      lg:mr-4
      flex-shrink-0
      transition-colors
      ease-in-out;

    &--selected {
      @apply bg-emerald-500;
    }

    &--unselected {
      @apply bg-neutral-50;
    }
  }
}
</style>
