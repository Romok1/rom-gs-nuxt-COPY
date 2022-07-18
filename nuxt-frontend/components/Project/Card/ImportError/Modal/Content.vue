<template>
  <div v-if="projectErrors" class="ct-content">
    <h2
      v-text="translation_id"
    />
    <TAlert
      v-bind="{
        dismissible: false,
        show: true,
        variant: 'danger',
      }"
      class="ct-content__alert"
    >
      <div class="ct-content__alert-wrapper">
        <div class="ct-content__aside">
          <IconWarning class="ct-content__icon" />
        </div>
        <div class="ct-content__body">
          <span
            class="ct-content__heading"
            v-text="translation_errorsDetected"
          />
          <p
            class="ct-content__subheading"
            v-text="translation_correctionMessage"
          />
        </div>
      </div>
    </TAlert>
    <ProjectCardImportErrorModalDataSources
      v-bind="{ dataSources: projectErrors }"
    />
  </div>
</template>

<script>
export default {
  props: {
    projectErrors: {
      type: Array,
      default: undefined
    },

    gefProject: {
      type: Object,
      default: undefined
    }
  },

  computed: {
    translation_id () {
      return this.$t('components.project.card.importError.modal.content.id', {
        id: this.gefProject.gefId
      })
    },

    translation_errorsDetected () {
      return this.$t(
        'components.project.card.importError.modal.content.errorsDetected',
        {
          errorCount: this.projectErrors.reduce(
            (sum, object) => sum + object.errors.length,
            0
          )
        }
      )
    },

    translation_correctionMessage () {
      return this.$t(
        'components.project.card.importError.modal.content.correctionMessage'
      )
    }
  }
}
</script>

<style lang="postcss" scoped>
.ct-content {
  &__alert {
    @apply p-4
      mb-6
      bg-theme-pink
      border-theme-red;
  }

  &__alert-wrapper {
    @apply flex
      justify-between
      space-x-4;
  }

  &__aside {
    @apply self-start;
  }

  &__icon {
    @apply w-14
      text-theme-red;
  }

  &__body {
    @apply self-center
      space-y-3;
  }

  &__heading {
    @apply text-h1
      font-bold;
  }

  &__subheading {
    @apply text-t1;
  }
}
</style>
