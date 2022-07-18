<template>
  <div class="ct-sidepanel">
    <TAlert
      v-bind="{ dismissible: false, show: true }"
      class="ct-sidepanel__title"
    >
      <h2
        class="ct-sidepanel__count"
        v-text="gefIdsCount"
      />
      <h3
        class="ct-sidepanel__subtitle"
        v-text="translation_projectsLocatedInCountry(georegionNames)"
      />
    </TAlert>

    <p
      class="ct-sidepanel__notice"
      v-text="translation_notice"
    />

    <slot />
  </div>
</template>

<script>
export default {
  computed: {
    gefIdsCount () {
      return this.$store.getters['portfolio/gefIds'].length || 0
    },

    georegions () {
      const selectedGeoregionIds = this.$store.getters['portfolio/selected/filters/georegions/all']
      const georegions = this.$store.getters['portfolio/filters/georegions/find']({ id: selectedGeoregionIds }) || []

      return georegions
    },

    georegionNames () {
      return this.georegions.map(georegion => georegion.name).join(', ')
    },

    translation_notice () {
      return this.$t('components.gefPortfolio.sidepanel.notice')
    }
  },

  methods: {
    translation_projectsLocatedInCountry (georegion) {
      return this.$t(
        'components.gefPortfolio.sidepanel.projectsLocatedInCountry',
        { georegion }
      )
    }
  }
}
</script>

<style lang="postcss" scoped>
.ct-sidepanel {
  @apply h-full
    space-y-4
    overflow-auto;

  &__title {
    @apply font-bold
      shadow-md;
  }

  &__count,
  &__subtitle {
    @apply text-black;
  }

  &__count {
    @apply text-h1;
  }

  &__subtitle {
    @apply text-t1;
  }

  &__notice {
    @apply text-t0;
  }
}
</style>
