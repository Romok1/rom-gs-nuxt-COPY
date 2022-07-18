<template>
  <div class="ct-banner">
    <div class="ct-banner__text">
      <slot name="text" />
    </div>
    <div class="ct-banner__image">
      <slot name="image" />
    </div>
  </div>
</template>

<style lang="postcss" scoped>
.ct-banner {
  @apply grid
    grid-cols-1
    gap-10;

  @screen lg {
    @apply grid-cols-2;
  }

  &__text {
    @apply self-center;
  }

  &__image {
    justify-self: end;
  }
}
</style>
