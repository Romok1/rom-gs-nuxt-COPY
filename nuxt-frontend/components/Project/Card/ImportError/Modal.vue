<template>
  <Portal to="modal">
    <Modal
      :show="showModal"
      @change="onChange"
    >
      <ProjectCardImportErrorModalContent
        v-bind="{ gefProject, projectErrors }"
      />
    </Modal>
  </Portal>
</template>

<script>

export default {

  props: {
    gefProject: {
      type: Object,
      default: undefined
    },

    projectErrors: {
      type: Array,
      default: undefined
    }
  },

  computed: {
    showModal () {
      return this.projectErrors !== undefined
    }
  },

  methods: {
    onChange () {
      this.redirectToGEFProjects()
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
