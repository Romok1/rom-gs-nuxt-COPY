<template>
  <ProjectCardImportErrorModal v-bind="{ gefProject, projectErrors }" />
</template>

<script>
export default {
  name: 'GEFProjectsIndexProjectIdImportErrorsPage',

  auth: true,

  async asyncData ({ $axios, params: { projectId } }) {
    if (projectId) {
      const [gefProject, projectErrors] = await Promise.all([
        $axios.$get(`/api/gef_projects/${projectId}`),
        $axios.$get(`/api/gef_projects/${projectId}/import_errors`)
      ])

      return {
        gefProject,
        projectErrors
      }
    }
  }
}
</script>
