<template>
  <div
    ref="card"
    class="ct-accordion-card"
    :class="{
      'ct-accordion-card--collapsed': collapsed
    }"
  >
    <div class="ct-accordion-card__heading">
      <span class="ct-accordion-card__label">
        <slot name="label" />
      </span>
      <GefPortfolioSidepanelIndicatorSummaryButton v-model="isCardSelected" />
    </div>
    <div class="ct-accordion-card__body">
      <slot />
    </div>
  </div>
</template>

<script>
export default {
  props: {
    indicator: {
      type: Object,
      required: true
    }
  },

  computed: {
    collapsed () {
      return !this.isCardSelected
    },

    isCardSelected: {
      set (isCardSelected) {
        if (isCardSelected) {
          const indicatorId = this.indicator.id

          this.$store.dispatch('portfolio/selected/indicatorId', indicatorId).then(() => {
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

            this.$scrollTo(this.$refs.card, 100)
          })
        }
      },

      get () {
        return this.$store.getters['portfolio/selected/indicatorId'] === this.indicator.id
      }
    }
  }
}
</script>

<style lang="postcss" scoped>
.ct-accordion-card {
  @apply rounded-md
    shadow-md;

  &__heading,
  &__body {
    @apply p-8;
  }

  &__heading {
    @apply flex
      justify-between
      items-center
      bg-theme-blueSemiLight
      rounded-t-md;
  }

  &__label {
    @apply text-t1
      font-bold;
  }

  &__body {
    @apply bg-white
      rounded-b-md;
  }

  &--collapsed &__heading {
    @apply rounded-b-md;
  }

  &--collapsed &__body {
    @apply hidden;
  }
}
</style>
