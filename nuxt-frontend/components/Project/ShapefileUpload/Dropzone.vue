<template>
  <div
    class="ct-dropzone ct-dropzone__container"
    :class="{ 'ct-dropzone--dragged-over': isDraggedOver }"
    @drop.prevent="onDrop"
    @drag.prevent="onDragover"
    @dragenter.prevent="onDragover"
    @dragleave.prevent="onDragleave"
    @dragover.prevent="onDragover"
  >
    <IconDragAndDrop class="ct-dropzone__icon" />
    <label
      class="ct-dropzone__label"
      v-text="translation_label"
    />
    <label
      class="ct-dropzone__label"
      v-text="translation_separator"
    />
    <label for="dropzone-input" class="ct-dropzone__input--wrapper" v-text="translation_button" />
    <TInput
      id="dropzone-input"
      class="ct-dropzone__input"
      type="file"
      :multiple="multiple"
      @change="onInputChange"
    />
    <p
      class="ct-dropzone__helper-text"
      v-text="translation_helperText"
    />
  </div>
</template>

<script>
import { delay } from 'lodash'

export default {
  props: {
    allowMultiple: {
      type: Boolean,
      default: true
    }
  },

  data () {
    return {
      isDraggedOver: false
    }
  },

  computed: {
    multiple () {
      return this.allowMultiple ? 'multiple' : undefined
    },

    translation_button () {
      return this.$t('components.project.shapefileUpload.dropzone.button')
    },

    translation_label () {
      return this.$t('components.project.shapefileUpload.dropzone.label')
    },

    translation_helperText () {
      return this.$t('components.project.shapefileUpload.dropzone.helperText')
    },

    translation_separator () {
      return this.$t('components.project.shapefileUpload.dropzone.separator')
    }
  },

  methods: {
    onInputChange (e) {
      this.$emit('change', e.target.files)
    },

    onDrop (e) {
      this.setDraggedOver(false)
      this.$emit('change', e.dataTransfer.files)
    },

    onDragover () {
      this.setDraggedOver(true)
      clearTimeout(this.dragTimeoutId)
    },

    onDragleave () {
      this.dragTimeoutId = delay(() => {
        this.setDraggedOver(false)
      }, 50)
    },

    setDraggedOver (isDraggedOver) {
      this.isDraggedOver = isDraggedOver === true
    }
  }
}
</script>

<style lang="postcss" scoped>
.ct-dropzone {
  @apply bg-neutral-50
    text-center
    p-12;

  &__container {
    @apply pb-4
      mb-6
      bg-theme-blueLight
      border-2
      border-theme-blue
      border-dashed
      p-12
      flex
      flex-col
      justify-center;
  }

  /* &--dragged-over {} @TODO: implement */

  &__icon {
    @apply h-16
      mb-6
      text-theme-blue;
  }

  &__label {
    @apply text-t1
      font-bold
      mb-6;
  }

  &__input {
    @apply hidden;

    &--wrapper {
      @apply mb-6
        font-medium
        self-center
        max-w-max
      /**
      * @TODO:
      * @see https://github.com/nuxt-community/tailwindcss-module/issues/415
      *
      * @apply t-button t-button--small;
      */
        inline-block
        text-t1
        font-bold
        p-3
        border-2
        md:px-14
        rounded-full
        disabled:bg-theme-blueLight
        disabled:border
        disabled:border-theme-blueLight
        disabled:cursor-not-allowed
        disabled:text-theme-gray
        transition
        duration-100
        ease-in-out
        focus:border-blue-600
        focus:outline-none
        focus:ring-2
        focus:ring-blue-600
        focus:ring-opacity-50

        text-t0
        p-2
        font-normal;
    }
  }

  &__helper-text {
    @apply italic
      text-subtext
      mb-2;
  }
}
</style>
