<template>
  <div class="ct-gef-portfolio">
    <div class="ct-gef-portfolio__filters">
      <Container>
        <GefPortfolioFilters v-bind="{ filterIds }" />
      </Container>
    </div>
    <div class="ct-gef-portfolio__indicators">
      <GefPortfolioSidepanel>
        <GefPortfolioSidepanelIndicators />
      </GefPortfolioSidepanel>
    </div>
    <div class="ct-gef-portfolio__map">
      <ClientOnly>
        <GefPortfolioMap />
      </ClientOnly>
    </div>
  </div>
</template>

<script>

export default {
  name: 'GEFPortfolioPage',

  async asyncData ({ store, $axios }) {
    await Promise.all([
      store.dispatch('portfolio/filters/focalAreas/initialize', { $axios }),
      store.dispatch('portfolio/filters/georegions/initialize', { $axios }),
      store.dispatch('portfolio/filters/users/initialize', { $axios }),
      store.dispatch('portfolio/initialize', { $axios })
    ])
  },

  computed: {
    filterIds () {
      const userFilters = this.$store.getters['portfolio/filters/users/all']

      const filterIds = [
        'focalAreas',
        'georegions'
      ]

      const hasUserFilters = userFilters.length > 0

      if (hasUserFilters) {
        filterIds.push('users')
      }

      return filterIds
    }
  }
}
</script>

<style lang="postcss" scoped>
.ct-gef-portfolio {
  width: 100%;
  display: grid;
  grid-template:
    "filters filters filters" min-content
    "indicators map map" 1fr / 1fr 1fr 1fr;

  &__filters {
    @apply bg-white
      shadow-md;

    grid-area: filters;
  }

  &__indicators {
    grid-area: indicators;
    max-height: calc(100vh - 13.75rem);
  }

  &__map {
    grid-area: map;
  }

  &__indicators,
  &__map {
    @apply p-4;
  }
}
</style>
