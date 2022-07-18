<template>
  <ProjectCardModal
    v-if="project"
    v-bind="{ project }"
  />
</template>

<script>
export default {
  name: 'GEFProjectsIndexProjectIdPage',

  auth: true,

  async asyncData ({ $axios, params: { projectId } }) {
    if (projectId) {
      const project = await $axios.$get(`/api/gef_projects/${projectId}`)

      return {
        project
      }
    }

    return {
      project: undefined
    }
  }
}
</script>
