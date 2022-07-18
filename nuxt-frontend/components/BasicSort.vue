<template>
  <TDropdown class="ct-sort">
    <template
      #trigger="{
        blurHandler,
        focusHandler,
        isShown,
        keydownHandler,
        mousedownHandler
      }"
    >
      <button
        class="ct-sort__trigger"
        aria-haspopup="true"
        @blur="blurHandler"
        @focus="focusHandler"
        @keydown="keydownHandler"
        @mousedown="mousedownHandler"
      >
        <span
          class="ct-sort__label"
          v-text="translation_label"
        />
        <IconChevronRight
          :class="isShown ? 'ct-sort__chevron--active' : 'ct-sort__chevron--inactive'"
          class="ct-sort__chevron"
        />
      </button>
    </template>
    <template
      #default="{ blurHandler, hide }"
    >
      <ul class="ct-sort__list">
        <li
          v-for="(sortingMethod, sortingMethodIndex) in sortingMethods"
          :key="sortingMethodIndex"
          class="ct-sort__list-item"
        >
          <button
            class="ct-sort__dropdown-item"
            role="menuitem"
            @click="onSortItemClick(sortingMethod.algorithm), hide()"
            @blur="blurHandler"
            v-text="sortingMethod.label"
          />
        </li>
      </ul>
    </template>
  </TDropdown>
</template>

<script>
export default {
  model: {
    event: 'change',
    prop: 'dataset'
  },

  props: {
    dataset: {
      type: Array,
      default: () => []
    },

    label: {
      type: String,
      default: undefined
    },

    sortingMethods: {
      type: Array,
      required: true,
      validator: sortingMethods =>
        sortingMethods.every((sortingMethod) => {
          /**
           * Every sorting method should be an object in format:
           * {
           *   algorithm: dataset => {},
           *   label: 'Sorting method name'
           * }
           * The algorithm returns the sorted dataset received.
           */
          try {
            return typeof sortingMethod.algorithm === 'function' &&
              typeof sortingMethod.label === 'string'
          } catch (e) {
            return false
          }
        })
    }
  },

  computed: {
    translation_label () {
      return this.label || this.$t('components.basicSort.label')
    }
  },

  methods: {
    onSortItemClick (sortingAlgorithm) {
      // Apply the sorting algorithm on the dataset.
      const mutatedDataset = [...this.dataset].sort(sortingAlgorithm)

      this.$emit('change', mutatedDataset)
    }
  }
}
</script>

<style lang="postcss" scoped>
.ct-sort {
  @apply flex
    ml-auto;

  &__trigger {
    @apply flex
      border
      border-theme-blue
      inline-block
      p-2
      rounded-3xl
      text-black
      text-t0
    /**
     * @TODO:
     * @see https://github.com/nuxt-community/tailwindcss-module/issues/415
     *
     * @apply t-button-secondary;
     */
      text-black
      bg-white
      border-theme-blueDark
      hover:text-blue-400;
  }

  &__label {
    @apply mr-6
      px-2;
  }

  &__chevron {
    @apply transition-transform
      text-theme-blue
      w-4;

    &--active {
      @apply -rotate-90;
    }

    &--inactive {
      @apply rotate-90;
    }
  }

  &__list {
    @apply space-y-6
      p-6;

    &-item {
      @apply flex
        justify-end;
    }
  }

  &__dropdown-item {
    @apply pb-1;
  }
}
</style>
