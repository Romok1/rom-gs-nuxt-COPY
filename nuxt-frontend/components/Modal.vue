<template>
  <TModal
    :value="show"
    @input="onInput"
  >
    <template
      #header
      class="flex items-center"
    >
      <slot name="header" />
    </template>
    <slot />
    <template #footer>
      <slot name="footer" />
    </template>
  </TModal>
</template>

<script>
export default {
  model: {
    event: 'change',
    prop: 'show'
  },

  props: {
    show: {
      type: Boolean,
      required: true
    }
  },

  mounted () {
    this.$nuxt.$on('modal:close', this.onInput)
  },

  methods: {
    onInput () {
      this.$emit('change', !this.show)
    }
  }
}
</script>
