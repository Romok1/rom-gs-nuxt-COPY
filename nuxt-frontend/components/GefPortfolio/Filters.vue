<template>
  <div class="ct-filters">
    <!-- grid-cols-1 grid-cols-2 grid-cols-3 -->
    <ul class="ct-filters__list" :class="listClasses">
      <li
        v-for="filterId in filterIds"
        :key="filterId"
        class="ct-filters__item"
      >
        <h4
          class="ct-filters__label"
          v-text="translation_label(filterId)"
        />
        <GefPortfolioFilter
          v-bind="{
            options: getOptions(filterId),
            value: getSelectedValues(filterId),
            configuration: filterConfiguration
          }"
          @change="onFilterChange(filterId, $event)"
        />
      </li>
    </ul>
  </div>
</template>

<script>
import { duplicate } from '~/functions/duplicate'

export default {
  props: {
    filterIds: {
      type: Array,
      default: () => []
    },

    filterConfiguration: {
      type: Object,
      default: () => ({})
    }
  },

  computed: {
    listClasses () {
      const numberOfColumnsToDisplay = this.filterIds.length

      return `grid-cols-${numberOfColumnsToDisplay}`
    }
  },

  methods: {
    getOptions (filterId) {
      return this.$store.getters[`portfolio/filters/${filterId}/all`]
    },

    getSelectedValues (filterId) {
      return this.$store.getters[`portfolio/selected/filters/${filterId}/all`]
    },

    onFilterChange (filterId, value) {
      this.$store.dispatch(`portfolio/selected/filters/${filterId}/store`, duplicate(value))

      const indicatorId = this.$store.getters['portfolio/selected/indicatorId']
      const {
        focalAreas,
        georegions,
        users,
        dateRange
      } = this.$store.getters['portfolio/selected/filters/filters']

      this.$store.dispatch.call(this, 'portfolio/chart/initialize', {
        focalAreas,
        georegions,
        users,
        dateRange,
        indicatorId
      })
    },

    translation_label (filterKey) {
      filterKey = filterKey.replace(/\//g, '.')

      return this.$t(`components.gefPortfolio.filters.labels.${filterKey}`)
    }
  }
}
</script>

<style lang="postcss" scoped>
.ct-filters {
  @apply py-2;

  &__list {
    @apply grid
      gap-4;
  }

  &__item {
    @apply col-span-1
      space-y-3
      pt-3
      pb-4;
  }

  &__label {
    @apply text-t1
      font-bold
      indent-4;
  }

  &__loading {
    @apply h-6
      w-6
      animate-spin;
  }
}
</style>
