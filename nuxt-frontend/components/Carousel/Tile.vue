<template>
  <div class="ct-tile">
    <div class="ct-tile__image" :style="imageStyle" />
    <div class="ct-tile__body">
      <h6 class="ct-tile__heading" v-text="heading" />
      <a class="ct-tile__link" :href="link">
        {{ translation_linkText }}
        <IconExternalLink class="ct-tile__icon" />
      </a>
    </div>
  </div>
</template>

<script>
export default {
  props: {
    backgroundImage: {
      type: String,
      required: true
    },

    heading: {
      type: String,
      required: true
    },

    link: {
      type: String,
      required: true
    }
  },

  computed: {
    imageStyle () {
      return {
        backgroundImage: `url(${this.backgroundImage})`
      }
    },

    translation_linkText () {
      return this.$t('components.tile.linkText')
    }
  }
}
</script>

<style lang="postcss" scoped>
.ct-tile {
  @apply bg-white
    rounded-md
    shadow-md
    h-full
    mx-3;

  &__image {
    @apply bg-center
      bg-cover
      h-[400px]
      rounded-t-md;
  }

  &__body {
    @apply py-8
      px-6;
  }

  &__heading {
    @apply text-h2
      mb-6;
  }

  &__link {
    @apply flex
      text-t1
      font-semibold
      mb-6;
  }

  &__icon {
    @apply ml-2
      text-theme-blue
      w-5;
  }
}
</style>
