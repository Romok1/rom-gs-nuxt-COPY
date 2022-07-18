<template functional>
  <div class="ct-container" :class="data.staticClass">
    <slot />
  </div>
</template>

<style lang="postcss" scoped>
.ct-container {
  @apply container mx-auto px-2 md:px-4;
}
</style>
