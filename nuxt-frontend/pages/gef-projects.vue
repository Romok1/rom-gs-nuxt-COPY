<template>
  <Container>
    <div class="ct-gef-projects">
      <ClientOnly>
        <ProjectSyncHeader
          class="ct-gef-projects__sync"
        />
      </ClientOnly>
      <div class="ct-gef-projects__header">
        <div class="ct-gef-projects__buttons">
          <PillFilters
            v-if="isTaskManager"
            v-model="viewMode"
            v-bind="{ options: viewModeOptions }"
          />
        </div>
        <BasicSort
          v-model="gefProjects"
          class="ct-gef-projects__sort"
          v-bind="{ sortingMethods: basicSort_sortingMethods }"
        />
      </div>
      <Spinner
        v-if="busy"
        class="ct-gef-projects__spinner"
      />
      <ProjectBanner
        v-if="!viewmodeHasResults"
        :banner="$t('pages.gefProjects.noResults')"
      />
      <div
        v-else
        class="ct-gef-projects__cards"
      >
        <ProjectCard
          v-for="project in gefProjects"
          :key="project.id"
          v-bind="project"
        />
        <NuxtChild />
      </div>
    </div>
  </Container>
</template>

<script>
import {
  RELOAD_GEF_PROJECTS_PAGE_EVENT_NAME,
  USER_ROLES
} from '~/constants'
import dynamicSort from '~/functions/dynamicSort'

const VIEWMODE_KEY = 'viewmode'
const VIEWMODE_ALL = 'default'
const VIEWMODE_ARCHIVED = 'archived'

export default {
  name: 'GEFProjectsPage',

  auth: true,

  key: to => to.fullPath,

  provide () {
    return {
      isTaskManager: this.isTaskManager
    }
  },

  data () {
    return {
      busy: false,
      gefProjects: [],
      lastSync: undefined,
      viewModeOptions: [
        {
          value: VIEWMODE_ALL,
          label: this.$t('pages.gefProjects.buttons.allProjects')
        },
        {
          value: VIEWMODE_ARCHIVED,
          label: this.$t('pages.gefProjects.buttons.archivedProjects')
        }
      ]
    }
  },

  async fetch () {
    this.busy = true
    const gefProjects = this.$route.query[VIEWMODE_KEY] === VIEWMODE_ARCHIVED
      ? await this.$axios.$get('/api/gef_projects?discarded=true')
      : await this.$axios.$get('/api/gef_projects')

    this.gefProjects = gefProjects
    this.busy = false
  },

  computed: {
    basicSort_sortingMethods () {
      return [
        {
          algorithm: dynamicSort('updatedAt'),
          label: this.$t('pages.gefProjects.sort.oldest')
        },
        {
          algorithm: dynamicSort('-updatedAt'),
          label: this.$t('pages.gefProjects.sort.newest')
        }
      ]
    },

    isTaskManager () {
      return this.$getUserRole() === USER_ROLES.taskManager
    },

    viewmodeHasResults () {
      return this.gefProjects?.length > 0 || this.busy
    },

    viewMode: {
      get () {
        return this.$route.query[VIEWMODE_KEY] === VIEWMODE_ARCHIVED
          ? VIEWMODE_ARCHIVED
          : VIEWMODE_ALL
      },
      set (viewMode) {
        this.$router.push({
          path: this.localePath('/gef-projects'),
          query: {
            [VIEWMODE_KEY]:
              viewMode === VIEWMODE_ARCHIVED ? VIEWMODE_ARCHIVED : VIEWMODE_ALL,
            s: '0' // Don't scroll to top.
          }
        })
      }
    }
  },

  watch: {
    viewMode (viewMode, oldViewMode) {
      if (viewMode !== oldViewMode) {
        this.$fetch()
      }
    }
  },

  watchQuery: [VIEWMODE_ARCHIVED],

  mounted () {
    this.$nuxt.$on(RELOAD_GEF_PROJECTS_PAGE_EVENT_NAME, this.$fetch)
  },

  created () {
    this.$nuxt.$on('fetch', this.$fetch)
  },

  beforeDestroy () {
    this.$nuxt.$off('fetch', this.$fetch)
  }
}
</script>

<style lang="postcss" scoped>
.ct-gef-projects {
  @apply flex
    flex-col
    h-full
    mt-9
    space-y-4;

  &__header {
    @apply flex
      justify-between
      w-full;
  }

  &__sync {
    @apply self-end
      mb-11;
  }

  &__sort {
    :deep(.t-dropdown__dropdown) {
      @apply origin-top-right
        right-0
        w-full
        mt-3;
    }
  }

  &__spinner {
    @apply flex
      content-center
      justify-center;
  }

  &__cards {
    @apply md:grid
      lg:gap-3
      lg:grid-cols-2
      2xl:grid-cols-3
      2xl:gap-6;
  }
}
</style>
