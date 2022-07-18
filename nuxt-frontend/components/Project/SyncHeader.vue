<template>
  <div class="ct-sync-header">
    <span class="ct-sync-header__label">
      <span
        class="ct-sync-header__last-update-label"
        v-text="translation_lastUpdateLabel"
      />
      <span class="ct-sync-header__duration" v-text="translation_duration" />
    </span>
    <button
      class="ct-sync-header__button"
      :class="{
        'ct-sync-header__button--busy': isBusy,
      }"
      @click="onButtonClick"
    >
      <IconSync
        class="ct-sync-header__icon"
      />
      <span class="ct-sync-header__button-text" v-text="translation_button" />
    </button>
  </div>
</template>

<script>
import { DateTime } from 'luxon'
import {
//   LAST_SYNC_CHANNEL_CLASSNAME,
  LAST_SYNC_ICON_ACTIVE_STATES,
  RELOAD_GEF_PROJECTS_PAGE_EVENT_NAME
} from '~/constants'
// import objectKeysToCamelCase from '~/functions/objectKeysToCamelCase'

export default {
  // channels: {
  //   [LAST_SYNC_CHANNEL_CLASSNAME]: {
  //     received (data) {
  //       this.lastSync = objectKeysToCamelCase(data)
  //     }
  //   }
  // },

  data () {
    return {
      lastSync: {
        updatedAt: undefined,
        status: undefined
      }
    }
  },

  computed: {
    isBusy () {
      return LAST_SYNC_ICON_ACTIVE_STATES.includes(this.lastSync.status)
    },

    translation_button () {
      return this.$t('components.project.syncHeader.button')
    },

    translation_duration () {
      return DateTime.fromISO(this.lastSync.updatedAt).toRelative()
    },

    translation_lastUpdateLabel () {
      return this.$t('components.project.syncHeader.lastUpdateLabel')
    }
  },

  watch: {
    isBusy (isBusy, prevIsBusy) {
      const busyNowButNotBusyBefore = isBusy && !prevIsBusy

      if (busyNowButNotBusyBefore) {
        // If we learn we are no longer busy - then an import just happened,
        // so emit an event that should be interpeted as a sign to reload the page.
        this.$nuxt.$emit(RELOAD_GEF_PROJECTS_PAGE_EVENT_NAME)
      }
    }
  },

  async created () {
    await this.updateLastSync()

    const oneMinuteInMilliseconds = 1000 * 60
    const fiveMinutesInMilliseconds = oneMinuteInMilliseconds * 5

    setInterval(this.updateLastSync, fiveMinutesInMilliseconds)
  },

  // mounted () {
  //   this.$cable.subscribe({ channel: LAST_SYNC_CHANNEL_CLASSNAME })

  //   const oneMinuteInMilliseconds = 60 * 1000

  //   setInterval(() => {
  //     // Trigger a re-render of the "Last Update" time.
  //     this.lastSync = { ...this.lastSync }
  //   }, oneMinuteInMilliseconds)
  // },

  methods: {
    onButtonClick () {
      if (this.isBusy) {
        console.warn('Cannot sync whilst busy.')
      } else {
        // Whether sync response is OK or not - update the last sync status.
        this.$axios.$post('/api/sync').finally(this.updateLastSync)
      }
    },

    updateLastSync () {
      this.$axios.$get('/api/last_sync').then((lastSync) => {
        this.lastSync = lastSync
      })
    }
  }
}
</script>

<style lang="postcss" scoped>
.ct-sync-header {
  @apply flex
    items-center
    space-x-6;

  &__label {
    @apply flex
      flex-nowrap
      space-x-2
      text-subtext;
  }

  &__last-update-label {
    @apply font-bold;
  }

  &__button {
    @apply flex
      items-center
      py-2
      px-4
      rounded-sm
      border
      border-theme-blue
      hover:border-theme-blueDark
      text-theme-blue
      hover:text-theme-blueDark
          /**
     * @TODO:
     * @see https://github.com/nuxt-community/tailwindcss-module/issues/415
     *
     * @apply t-button;
     */
      inline-block
      text-t1
      font-bold
      p-3
      border-2
      md:px-14
      rounded-full
      disabled:bg-theme-blueLight
      disabled:border
      disabled:border-theme-blueLight
      disabled:cursor-not-allowed
      disabled:text-theme-gray
      transition
      duration-100
      ease-in-out
      focus:border-blue-600
      focus:outline-none
      focus:ring-2
      focus:ring-blue-600
      focus:ring-opacity-50;

    &--busy {
      @apply text-theme-gray
        border-theme-gray
        hover:text-theme-red
        hover:border-theme-red
        cursor-not-allowed;
    }
  }

  &__icon {
    @apply h-7;

    .ct-sync-header__button--busy & {
      @apply animate-spin;
    }
  }

  &__button-text {
    @apply font-bold;
  }
}
</style>
