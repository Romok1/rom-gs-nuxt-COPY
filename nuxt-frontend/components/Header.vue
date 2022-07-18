<template>
  <header
    class="ct-header"
    :class="{ 'ct-header--fixed': fixed }"
    :style="{ backgroundImage: `url('${image}')`, minHeight: `${minHeight}vh` }"
  >
    <div class="ct-header__container" :style="{ minHeight: `${minHeight}vh` }">
      <div class="ct-header__body">
        <slot />
      </div>
    </div>
  </header>
</template>

<script>
export default {
  props: {
    image: {
      type: String,
      required: true
    },

    minHeight: {
      type: Number,
      default: 33
    },

    fixed: {
      type: Boolean,
      default: false
    }
  }
}
</script>

<style lang="postcss" scoped>
.ct-header {
  @apply bg-center
    bg-cover
    bg-theme-blueLight
    flex
    flex-col
    items-center
    justify-center;

  &--fixed {
    @apply bg-fixed;
  }

  &__container {
    @apply w-full
      flex
      items-center;
  }

  &__body {
    @apply items-center
      flex
      flex-col
      space-y-8
      pt-24
      pb-16
      px-16
      lg:pt-44
      lg:pb-44
      lg:px-80;
  }
}
</style>
