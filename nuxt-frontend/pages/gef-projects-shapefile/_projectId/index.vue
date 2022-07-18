<template>
  <ProjectShapefileUploadForm class="ct-page" v-bind="{ gefProject, shapefile }" />
</template>

<script>
export default {
  name: 'GEFProjectsShapefileProjectIdPage',

  auth: true,

  async asyncData ({ $axios, params }) {
    const [gefProject, shapefile] = await Promise.all([
      $axios.$get(`/api/gef_projects/${params.projectId}`),
      $axios.$get(`/api/gef_projects/${params.projectId}/shapefile`)
    ])

    return {
      gefProject,
      shapefile
    }
  }
}
</script>

<style lang="postcss" scoped>
.ct-page {
  @apply my-4 w-full;
}
</style>
