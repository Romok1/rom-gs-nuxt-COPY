<template>
  <ul class="ct-timeline">
    <li
      v-for="(timelineItem, timelineIndex) in timeline"
      :key="timelineIndex"
      class="ct-timeline__item"
    >
      <div
        :class="timelineIndicatorClasses(timelineItem, timelineIndex)"
        class="ct-timeline__indicator"
      />
      <div
        class="ct-timeline__name"
        v-text="timelineItem.name"
      />
      <div
        class="ct-timeline__date"
        v-text="formatDate(timelineItem.date)"
      />
    </li>
  </ul>
</template>

<script>
import { DateTime } from 'luxon'

const isoDateStringToDateTime = dateString => DateTime.fromISO(dateString)

const isDateBeforeToday = (date) => {
  const dateToday = DateTime.now()

  return date < dateToday
}

export default {
  props: {
    timeline: {
      type: Array,
      required: true
    }
  },

  computed: {
    lastIndex () {
      return this.timeline.length - 1
    }
  },

  methods: {
    formatDate (dateString) {
      return dateString ? isoDateStringToDateTime(dateString).toFormat('d - MMM - yyyy') : ''
    },

    timelineIndicatorClasses (timelineItem, timelineIndex) {
      const classes = []
      const noDateNotLastIndex = !timelineItem.date && timelineIndex !== this.lastIndex
      const dateBeforeToday = isDateBeforeToday(isoDateStringToDateTime(timelineItem.date))

      if (noDateNotLastIndex || dateBeforeToday) {
        classes.push('ct-timeline__indicator--filled')
      }

      return classes
    }
  }
}
</script>

<style lang="postcss" scoped>
.ct-timeline {
  @apply mb-3;

  &__item {
    @apply ml-[0.4063rem]
      pl-6
      relative
      border-l
      border-black;

    &:last-child {
      @apply border-transparent;
    }
  }

  &__indicator {
    @apply h-[0.875rem]
      w-[0.875rem]
      rounded-full
      border-theme-blue
      border-2
      bg-white
      absolute
      left-[-0.4375rem]
      top-0;

    &--filled {
      @apply bg-theme-blue;
    }
  }

  &__name {
    @apply font-bold pb-3;
  }

  &__date {
    @apply pb-3;
  }
}
</style>
