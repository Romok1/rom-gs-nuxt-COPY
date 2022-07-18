<template>
  <div class="ct-errors">
    <ul class="ct-errors__items">
      <li
        v-for="(
          error, errorIndex
        ) in errors"
        :key="errorIndex"
        class="ct-errors__item"
      >
        <h4
          class="ct-errors__heading"
          v-text="translation_heading(error.rowNumber)"
        />
        <p class="ct-errors__text" v-text="error.message" />
      </li>
    </ul>
  </div>
</template>

<script>
export default {
  props: {
    errors: {
      type: Array,
      required: true
    }
  },

  methods: {
    translation_heading (rowNumber) {
      return this.$t(
        'components.project.card.importError.modal.content.dataSource.errors.rowNumber',
        { rowNumber }
      )
    }
  }
}
</script>

<style lang="postcss" scoped>
.ct-errors {
  &__heading {
    @apply font-bold
      text-t0
      mt-5;
  }

  &__text {
    @apply text-t0;
  }
}
</style>
