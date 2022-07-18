<template>
  <div
    v-if="project"
    class="ct-content"
  >
    <div class="ct-content__head">
      <h2
        class="ct-content__id"
        v-text="translation_id"
      />
      <ProjectCardPill
        v-if="true"
        v-bind="{ statusType: currentStatusType }"
        v-text="`${project.currentStatus}`"
      />
    </div>

    <TAlert
      v-if="project.title"
      v-bind="{ dismissible: false, show: true }"
      class="ct-content__title"
      v-text="project.title"
    />

    <div class="ct-content__links">
      <ProjectCardExternalLink to="#">
        {{ $t("project.card.moreInfoModal.links.dashboard") }}
      </ProjectCardExternalLink>
      <ProjectCardExternalLink to="#">
        {{ $t("project.card.moreInfoModal.links.gefWebsite") }}
      </ProjectCardExternalLink>
    </div>

    <div class="ct-content__section">
      <h4
        class="ct-content__subheading"
        v-text="$t('project.card.moreInfoModal.headings.location')"
      />
      <div
        class="ct-content__subtext"
        v-text="translation_joinCollecion(project.georegions)"
      />
    </div>

    <div class="ct-content__section">
      <h4
        class="ct-content__subheading"
        v-text="$t('project.card.moreInfoModal.headings.implementingAgencies')"
      />
      <div
        class="ct-content__subtext"
        v-text="translation_joinCollecion(project.implementingAgencies)"
      />
    </div>

    <div class="ct-content__section">
      <h4
        class="ct-content__subheading"
        v-text="$t('project.card.moreInfoModal.headings.projectGrant')"
      />
      <div
        class="ct-content__subtext"
        v-text="translation_orCommonUnavailable(project.projectGrant)"
      />
    </div>

    <div class="ct-content__section">
      <h4
        class="ct-content__subheading"
        v-text="$t('project.card.moreInfoModal.headings.focalAreas')"
      />
      <div
        class="ct-content__subtext"
        v-text="translation_joinCollecion(project.focalAreas)"
      />
    </div>

    <div class="ct-content__section">
      <h4
        class="ct-content__heading"
        v-text="$t('project.card.moreInfoModal.headings.projectTimeline')"
      />
    </div>

    <ProjectTimeline v-bind="{ timeline: project.timeline }" />

    <div class="ct-content__section">
      <h4
        class="ct-content__subheading"
        v-text="$t('project.card.moreInfoModal.headings.midTermEvaluationStatus')"
      />
      <div class="ct-content__subtext">
        <ProjectCardPill
          v-if="project.midTermEvaluationStatus"
          v-bind="{ statusType: pillStatusCode(project.midTermEvaluationStatus) }"
          v-text="translation_statusText(project.midTermEvaluationStatus)"
        />
        <span
          v-else
          v-text="$t('common.unavailable')"
        />
      </div>

      <h4
        class="ct-content__subheading"
        v-text="$t('project.card.moreInfoModal.headings.terminalEvaluationStatus')"
      />
      <div class="ct-content__subtext">
        <ProjectCardPill
          v-if="project.terminalEvaluationStatus"
          v-bind="{ statusType: pillStatusCode(project.terminalEvaluationStatus) }"
          v-text="translation_statusText(project.terminalEvaluationStatus)"
        />
        <span
          v-else
          v-text="$t('common.unavailable')"
        />
      </div>
    </div>

    <div class="ct-content__section">
      <h3
        class="ct-content__heading"
        v-text="$t('project.card.moreInfoModal.headings.projectFocals')"
      />
    </div>

    <div class="ct-content__section">
      <h4
        class="ct-content__subheading"
        v-text="$t('project.card.moreInfoModal.headings.taskManager')"
      />
      <div
        class="ct-content__subtext"
        v-text="translation_taskManagerName"
      />
    </div>

    <div class="ct-content__section">
      <h4
        class="ct-content__subheading"
        v-text="$t('project.card.moreInfoModal.headings.paFocalPoint')"
      />
      <div
        class="ct-content__subtext"
        v-text="project.paFocalPoint ? project.paFocalPoint.name : $t('common.unavailable')"
      />
    </div>

    <div class="ct-content__section">
      <h4
        class="ct-content__subheading"
        v-text="$t('project.card.moreInfoModal.headings.fmo')"
      />
      <div
        class="ct-content__subtext"
        v-text="project.fmo ? project.fmo.name : $t('common.unavailable')"
      />
    </div>

    <div class="ct-content__section">
      <h4
        class="ct-content__subheading"
        v-text="$t('project.card.moreInfoModal.headings.faFocalPoint')"
      />
      <div
        class="ct-content__subtext"
        v-text="project.faFocalPoint ? project.faFocalPoint.name : $t('common.unavailable')"
      />
    </div>

    <div class="ct-content__footer">
      <slot name="footer" />
    </div>
  </div>
</template>

<script>
import {
  GEF_PROJECT_VALID_STATUSES,
  GEF_PROJECT_PILL_STATUS_MAPPING,
  GEF_PROJECT_PILL_STATUS_MAPPING_DEFAULT
} from '~/constants'

export default {
  props: {
    currentStatusType: {
      type: String,
      default: 'unknown'
    },

    project: {
      type: Object,
      default: undefined
    }
  },

  computed: {
    translation_id () {
      return this.$t('project.card.moreInfoModal.headings.id', {
        id: this.project.gefId
      })
    },

    translation_taskManagerName () {
      return this.translation_orCommonUnavailable(
        this.project.taskManager?.name
      )
    }
  },

  methods: {
    pillStatusCode (status) {
      try {
        return GEF_PROJECT_PILL_STATUS_MAPPING[status]
      } catch (_err) {
        return GEF_PROJECT_PILL_STATUS_MAPPING_DEFAULT
      }
    },

    translation_joinCollecion (
      collection,
      options = { attribute: 'name', separator: ', ' }
    ) {
      const { attribute, separator } = options

      return collection
        .map(collectionItem => collectionItem[attribute])
        .join(separator)
    },

    translation_orCommonUnavailable (value) {
      return value || this.$t('common.unavailable')
    },

    translation_statusText (status) {
      const localeKey = GEF_PROJECT_VALID_STATUSES[status]

      return this.$t(`constants.gefProjectValidStatuses.${localeKey}`)
    }
  }
}
</script>

<style lang="postcss" scoped>
.ct-content {
  &__id {
    @apply text-t1
      font-bold
      self-end;
  }

  &__head {
    @apply flex
      justify-between
      px-6
      pb-6
      mb-8
      border-b-2
      border-theme-blue;
  }

  &__title {
    @apply mb-6;
  }

  &__heading {
    @apply py-6
      mb-8
      border-b-2
      border-theme-blue
      text-t1
      font-bold;
  }

  &__subheading {
    @apply text-subtext
      font-bold;
  }

  &__links {
    @apply text-subtext
      flex
      flex-row
      justify-end
      space-x-4
      lg:space-x-9
      mb-8
      tracking-wide;
  }

  &__section {
    @apply space-y-3
      mb-8;
  }

  &__footer {
    @apply pt-6
      border-t-2
      border-theme-blue;
  }
}
</style>
