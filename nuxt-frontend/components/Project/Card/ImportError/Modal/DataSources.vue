<template>
  <div class="ct-data-sources">
    <ul class="ct-data-sources__items">
      <li
        v-for="(dataSourceErrors, dataSourceIndex) in dataSources"
        :key="dataSourceIndex"
      >
        <h4
          class="ct-data-sources__heading"
          v-text="translation_dataSource(dataSourceErrors.dataSource)"
        />
        <ProjectCardImportErrorModalContentDataSourceErrors
          v-bind="{ errors: dataSourceErrors.errors }"
        />
      </li>
    </ul>
  </div>
</template>

<script>
export default {
  props: {
    dataSources: {
      type: Array,
      default: undefined
    }
  },

  methods: {
    translation_dataSource (dataSource) {
      return this.$t(
        'components.project.card.importError.modal.dataSources.dataSource',
        { dataSource }
      )
    }
  }
}
</script>

<style lang="postcss" scoped>
.ct-data-sources {
  &__items {
    @apply space-y-8;
  }

  &__heading {
    @apply text-t1
      border-b
      border-theme-blue
      pb-2
      mb-4;
  }
}
</style>
