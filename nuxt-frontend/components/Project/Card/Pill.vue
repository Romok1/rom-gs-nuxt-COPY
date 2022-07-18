<template>
  <span class="ct-pill" :class="computedClasses">
    <slot />
  </span>
</template>

<script>
import { STATUS_TYPES } from '~/constants'

const hasStatusType = (statusType) => {
  return Object.prototype.hasOwnProperty.call(STATUS_TYPES, statusType)
}

export default {
  props: {
    statusType: {
      type: String,
      default: undefined,
      validator: hasStatusType
    }
  },

  computed: {
    computedClasses () {
      const statusType = hasStatusType(this.statusType)
        ? STATUS_TYPES[this.statusType]
        : STATUS_TYPES.unknown

      return `ct-pill--${statusType}`
    }
  }
}
</script>

<style lang="postcss" scoped>
.ct-pill {
  @apply inline-block rounded-3xl p-2 text-t0 text-black;

  &--success {
    @apply bg-theme-greenLight/50 border-2 border-theme-green;
  }

  &--warning {
    @apply bg-theme-amber/80 border-2 border-amber-500;
  }

  &--info {
    @apply bg-theme-blue/50 border-2 border-theme-blueDark;
  }

  &--pending {
    @apply bg-theme-purple/50 border-2 border-purple-900;
  }

  &--error {
    @apply bg-theme-red border-2 border-red-700;
  }

  &--unknown {
    @apply bg-slate-100 border-2 border-slate-300;
  }
}
</style>
