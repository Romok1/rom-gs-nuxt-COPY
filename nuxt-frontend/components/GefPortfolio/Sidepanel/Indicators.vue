<template>
  <div class="ct-indicators">
    <h3
      class="ct-indicators__heading"
      v-text="translation_heading"
    />

    <h4
      class="ct-indicators__filters-label"
      v-text="translation_dateFilter"
    />

    <GefPortfolioFilters
      v-bind="{ filterIds, filterConfiguration }"
      class="ct-indicators__filters"
    />

    <GefPortfolioSidepanelIndicatorTypeSelector
      v-model="indicatorTypeId"
      class="ct-indicators__type-selector"
      v-bind="{ options: indicatorTypes }"
    />

    <ul class="ct-indicators__list">
      <li
        v-for="indicator in indicators"
        :key="indicator.id"
        class="ct-indicators__item"
      >
        <GefPortfolioSidepanelIndicatorSummaryAccordionCard v-bind="{ indicator }">
          <template #label>
            {{ indicator.name }}
          </template>
          <template #default>
            <GefPortfolioChart />
          </template>
        </GefPortfolioSidepanelIndicatorSummaryAccordionCard>
      </li>
    </ul>
  </div>
</template>

<script>
export default {
  computed: {
    filterIds () {
      return [
        'dateRange/from',
        'dateRange/to'
      ]
    },

    filterConfiguration () {
      return {
        clearable: false,
        hideSearchBox: true,
        multiple: false
      }
    },

    indicatorTypeId: {
      set (indicatorTypeId) {
        this.$store.dispatch('portfolio/selected/indicatorTypeId', indicatorTypeId)
      },

      get () {
        return this.$store.getters['portfolio/selected/indicatorTypeId']
      }
    },

    indicatorTypes () {
      return this.$store.getters['portfolio/indicatorTypes']
    },

    indicators () {
      return this.$store.getters['portfolio/indicators']
    },

    translation_heading () {
      return this.$t('components.gefPortfolio.sidepanel.indicators.heading')
    },

    translation_dateFilter () {
      return this.$t('components.gefPortfolio.filters.labels.dateRange.heading')
    }
  }
}
</script>

<style lang="postcss" scoped>
.ct-indicators {
  &__heading {
    @apply text-t1
      font-bold
      block
      py-4
      mb-6
      border-b
      border-theme-blue;
  }

  &__filters {
    &-label {
      @apply text-subtext
        font-bold;
    }

    :deep(.ct-filters) {
      &__list { /* stylelint-disable-line plugin/stylelint-bem-namics */
        @apply flex;
      }

      &__label { /* stylelint-disable-line plugin/stylelint-bem-namics */
        @apply font-normal
          mr-6;
      }

      &__item { /* stylelint-disable-line plugin/stylelint-bem-namics */
        @apply flex
          flex-row
          items-center;

        &:first-child { /* stylelint-disable-line plugin/stylelint-bem-namics */
          .ct-filters__label { /* stylelint-disable-line plugin/stylelint-bem-namics */
            /* Don't show the first filter label - per design. */
            @apply hidden;
          }
        }
      }
    }
  }

  :deep(.ct-filter) {
    @apply w-full
      min-w-[6rem]
      md:min-w-[10rem]
      !mt-0;
  }

  &__type-selector {
    @apply my-4;
  }

  &__list {
    @apply space-y-4;
  }
}
</style>
