<template>
  <div class="ct-banner">
    <div class="ct-banner__inner-text">
      {{ banner.text }}
    </div>
  </div>
</template>

<script>
export default {
  props: {
    banner: {
      type: Object,
      default: () => ({})
    }
  }
}
</script>

<style lang="postcss" scoped>
.ct-banner {
  @apply flex
    h-full
    flex-col
    content-center
    justify-center;

  &__inner-text {
    @apply text-h2
      font-bold
      text-center;
  }
}
</style>
