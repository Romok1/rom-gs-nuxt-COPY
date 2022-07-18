<template>
  <div class="ct-card">
    <div class="ct-card__header">
      <span class="ct-card__id" v-text="translation_id" />
      <ProjectCardImportError
        v-if="internalShowErrors"
        v-bind="{ gefId }"
      />
      <ProjectCardPill
        v-if="currentStatus"
        v-bind="{ statusType: currentStatusType }"
      >
        {{ currentStatus }}
      </ProjectCardPill>
    </div>
    <div class="ct-card__body">
      <div class="ct-card__summary">
        <div class="ct-card__heading">
          <div
            class="ct-card__heading-label"
            v-text="$t('project.card.labels.title')"
          />
          <h2 class="ct-card__heading-text" v-text="translation_title" />
        </div>
        <div class="ct-card__heading">
          <div
            class="ct-card__heading-label"
            v-text="$t('project.card.labels.georegions')"
          />
          <h2 class="ct-card__heading-text" v-text="translation_georegions" />
        </div>
      </div>
      <ProjectUploadButton v-if="isTaskManager" />
      <div class="ct-card__buttons">
        <TButton
          class="ct-card__button"
          variant="secondary"
          @click="onMoreInfoButtonClick"
          v-text="$t('project.card.buttons.moreInfo')"
        />
        <TButton
          class="ct-card__button"
          v-text="$t('project.card.buttons.exploreMap')"
        />
      </div>
    </div>
  </div>
</template>

<script>
import {
  STATUS_TYPES,
  GEF_PROJECT_CURRENT_STATUS_TYPE_MAPPINGS
  // IMPORT_ERROR_COUNT_CHANNEL_CLASS,
  // IMPORT_ERROR_COUNT_CHANNEL
} from '~/constants'

export default {
  // channels: {
  //   computed: [
  //     {
  //       channelName () {
  //         return this.customChannelNameForGefProject
  //       },
  //       received (data) {
  //         this.internalShowErrors = data === true
  //       }
  //     }
  //   ]
  // },

  inject: ['isTaskManager'],

  provide () {
    return {
      id: this.id,
      gefId: this.gefId,
      shapefile: this.shapefile
    }
  },

  props: {
    id: {
      type: Number,
      required: true
    },

    gefId: {
      type: [Number, String],
      required: true
    },

    title: {
      type: String,
      default: null
    },

    georegions: {
      type: Array,
      default: () => []
    },

    createdAt: {
      type: String,
      default: undefined
    },

    currentStatus: {
      type: String,
      default: undefined
    },

    hasImportErrors: {
      type: Boolean,
      default: undefined
    },

    midTermEvaluationStatus: {
      type: String,
      default: undefined
    },

    projectGrant: {
      type: String,
      default: undefined
    },

    shapefile: {
      type: Object,
      default: undefined
    },

    shortTitle: {
      type: String,
      default: undefined
    },

    terminalEvaluationStatus: {
      type: String,
      default: undefined
    },

    updatedAt: {
      type: String,
      default: undefined
    }
  },

  data () {
    return {
      internalShowErrors: false
    }
  },

  computed: {
    currentStatusType () {
      try {
        return GEF_PROJECT_CURRENT_STATUS_TYPE_MAPPINGS[
          this.currentStatus.toLowerCase()
        ]
      } catch (e) {
        console.warn('Current status color mismatch.')
      }

      return STATUS_TYPES.unknown
    },

    // customChannelNameForGefProject () {
    //   return `${IMPORT_ERROR_COUNT_CHANNEL}:${this.gefId}`
    // },

    translation_id () {
      return this.$t('project.card.id', { id: this.gefId })
    },

    translation_title () {
      return this.title || this.$t('common.unavailable')
    },

    translation_georegions () {
      return this.georegions.length > 0
        ? this.georegions.map(georegion => georegion.name).join(', ')
        : this.$t('common.unavailable')
    }
  },

  created () {
    this.internalShowErrors = this.hasImportErrors === true
  },

  // mounted () {
  //   this.subscribeToImportErrorsChannel()
  // },

  methods: {
    onMoreInfoButtonClick () {
      this.$router.push({
        path: this.localePath(`/gef-projects/${this.gefId}`),
        query: this.$route.query
      })
    }

    // subscribeToImportErrorsChannel () {
    //   this.$cable.subscribe(
    //     {
    //       channel: IMPORT_ERROR_COUNT_CHANNEL_CLASS,
    //       gef_id: this.gefId
    //     },
    //     this.customChannelNameForGefProject
    //   )
    // }
  }
}
</script>

<style lang="postcss" scoped>
.ct-card {
  &__header,
  &__body {
    @apply bg-white;
  }

  &__header {
    @apply flex
      flex-nowrap
      items-center
      justify-between
      py-3
      px-4
      rounded-t-lg
      border
      border-transparent
      border-b-theme-blue;
  }

  &__body {
    @apply py-8
      px-6
      rounded-b-lg;
  }

  &__id {
    @apply text-subtext
      font-bold;
  }

  &__heading {
    @apply mb-6;

    &-label {
      @apply text-t0
        mb-2;
    }

    &-text {
      @apply text-subtext
        font-bold;
    }
  }

  &__buttons {
    @apply space-y-4
      flex
      flex-col
      xl:flex-row
      xl:space-y-0
      xl:justify-between;
  }
}
</style>
