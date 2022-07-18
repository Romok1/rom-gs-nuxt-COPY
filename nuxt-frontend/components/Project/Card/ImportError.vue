<template>
  <span class="ct-warning" @click="onContentWarningClick">
    <IconWarning class="ct-warning__icon" />
    <span class="ct-warning__text" v-text="translation_text" />
  </span>
</template>

<script>
export default {
  props: {
    gefId: {
      type: String,
      required: true
    }
  },

  computed: {
    translation_text () {
      return this.$t('components.project.card.importError.text')
    }
  },

  methods: {
    onContentWarningClick () {
      this.$router.push({
        path: this.localePath(`/gef-projects/${this.gefId}/import-errors`),
        query: this.$route.query
      })
    }
  }
}
</script>

<style lang="postcss" scoped>
.ct-warning {
  @apply p-2
    flex
    items-center
    space-x-1
    font-bold
    text-subtext
    text-theme-red
    cursor-pointer;

  &__icon {
    @apply w-5;
  }
}
</style>
