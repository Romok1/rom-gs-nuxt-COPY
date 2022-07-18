<template>
  <Portal to="modal">
    <Modal
      :show="showModal"
      @change="onChange"
    >
      <ProjectCardModalContent v-bind="{ project, currentStatusType }">
        <template #footer>
          <TButton
            v-if="isTaskManager"
            class="ct-modal__button ct-modal__button--icon"
            variant="secondary"
            @click="onArchiveProjectButtonClick"
          >
            <IconInbox class="ct-modal__icon--archive" />
            <span v-text="translation_archiveButton" />
          </TButton>
        </template>
      </ProjectCardModalContent>
    </Modal>
  </Portal>
</template>

<script>
import { STATUS_TYPES, GEF_PROJECT_CURRENT_STATUS_TYPE_MAPPINGS } from '~/constants'

export default {
  inject: ['isTaskManager'],

  props: {
    project: {
      type: Object,
      default: undefined
    }
  },

  computed: {
    currentStatusType () {
      try {
        return GEF_PROJECT_CURRENT_STATUS_TYPE_MAPPINGS[this.currentStatus.toLowerCase()]
      } catch (e) {
        console.warn('Current status color mismatch.')
      }

      return STATUS_TYPES.unknown
    },

    showModal () {
      return this.project !== undefined
    },

    translation_archiveButton () {
      return this.project.discardedAt
        ? this.$t('project.card.buttons.restore')
        : this.$t('project.card.buttons.archive')
    }
  },

  methods: {
    onChange () {
      this.redirectToGEFProjects()
    },

    onArchiveProjectButtonClick () {
      const mode = this.project.discardedAt
        ? '$put'
        : '$delete'

      this.$axios[mode](`/api/gef_projects/${this.project.gefId}`)
        .then(() => {
          this.$nuxt.$emit('fetch')
          this.redirectToGEFProjects()
        })
        .catch((e) => {
          console.error(e)
        })
    },

    redirectToGEFProjects () {
      this.$router.push({
        path: this.localePath('/gef-projects'),
        query: this.$route.query
      })
    }
  }
}
</script>

<style lang="postcss" scoped>
.ct-modal {
  &__button {
    &--icon {
      @apply inline-flex
        items-center
        space-x-3;
    }
  }

  &__icon {
    &--archive {
      @apply inline-block
        h-8;
    }
  }
}
</style>
