<template>
  <div class="ct-tooltip">
    <slot />
    <div
      role="tooltip"
      class="ct-tooltip__tooltip"
    >
      <slot name="tooltip" />
      <div class="ct-tooltip__arrow" />
    </div>
  </div>
</template>

<style lang="postcss" scoped>
.ct-tooltip {
  @apply relative;

  &__tooltip {
    @apply hidden
      absolute
      top-[calc(100%+1.25rem)]
      -translate-x-1/2
      left-1/2
      z-20
      py-2
      px-8
      text-neutral-600
      bg-neutral-50
      border
      shadow-sm
      opacity-0
      transition
      whitespace-nowrap;

    &:hover & {
      @apply block
        opacity-100;
    }

    &:focus & {
      @apply opacity-100;
    }
  }

  &__arrow {
    @apply absolute
      -top-2
      left-[calc(50%-0.5rem)]
      bg-neutral-50
      border-t border-l
      z-10
      w-4
      h-4
      rotate-45;
  }
}
</style>
