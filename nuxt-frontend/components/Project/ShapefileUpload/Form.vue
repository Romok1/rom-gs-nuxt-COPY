<template>
  <form
    class="ct-form"
    @submit.prevent="onSaveButtonClick"
  >
    <h3
      class="ct-form__title"
      v-text="translation_title"
    />
    <TAlert
      v-bind="{ dismissible: false, show: true }"
      class="ct-form__header"
    >
      <h1
        class="ct-form__id"
        v-text="translation_id"
      />
      <h2
        class="ct-form__project-name"
        v-text="translation_projectName"
      />
    </TAlert>
    <ProjectShapefileUploadDropzone @change="onDropzoneChange" />
    <ProjectShapefileUploadFilelist v-bind="{ blobs }" @change="onBlobsChange" />
    <div class="ct-form__cta">
      <TButton
        type="reset"
        v-bind="{ variant: 'secondary' }"
        v-text="translation_cancel"
      />
      <TButton
        type="submit"
        v-text="translation_save"
      />
    </div>
  </form>
</template>

<script>
import objectKeysToCamelCase from '~/functions/objectKeysToCamelCase'

const ACTIVE_STORAGE_SRC = 'https://unpkg.com/@rails/activestorage@6.0.5/app/assets/javascripts/activestorage.js'

export default {
  props: {
    gefProject: {
      type: Object,
      required: true
    },

    shapefile: {
      type: Object,
      required: true
    }
  },

  data () {
    return {
      blobs: []
    }
  },

  head () {
    return {
      script: [
        {
          src: ACTIVE_STORAGE_SRC
        }
      ]
    }
  },

  computed: {
    translation_id () {
      return this.$t('components.project.shapefileUpload.id', { id: this.gefProject.gefId })
    },

    translation_projectName () {
      return this.gefProject.title
    },

    translation_title () {
      return this.$t('components.project.shapefileUpload.title')
    },

    translation_pill () {
      return this.$t('components.project.shapefileUpload.pill')
    },

    translation_cancel () {
      return this.$t('common.cancel')
    },

    translation_save () {
      return this.$t('common.save')
    }
  },

  created () {
    this.setBlobs(this.shapefile.files)
  },

  methods: {
    onBlobsChange (blobs) {
      this.setBlobs(blobs)
    },

    onDropzoneChange (files) {
      this.uploadFilesToActiveStorage(files)
    },

    uploadFilesToActiveStorage (files) {
      for (const file of files) {
        const upload = new window.ActiveStorage.DirectUpload(
          file,
          `${this.$config.railsEndpoint}rails/active_storage/direct_uploads`,
          this
        )

        this.blobs.push({
          filename: file.name
        })

        setTimeout(() => {
          upload.create((error, blob) => {
            if (error) {
              console.error(error)
            } else {
              const blobInCamelCase = objectKeysToCamelCase(blob)

              this.setBlobs(
                this.blobs.map((innerBlob) => {
                  if (!innerBlob.signedId && innerBlob.filename === blob.filename) {
                    return blobInCamelCase
                  }

                  return innerBlob
                })
              )
            }
          })
        }, 500)
      }
    },

    onDelete (blobId) {
      // This might need to be refactored to two arrays, one for display and one
      // for tracking files and sending _destroy to the backend.
      this.setBlobs(
        this.blobs.filter(blob => blob.signed_id !== blobId)
      )
    },

    onSaveButtonClick () {
      this.$axios.$put(
        `${this.$config.railsApiEndpoint}gef_projects/${this.gefProject.gefId}/shapefile`,
        {
          shapefile: {
            files: this.blobs
          }
        }
      )
    },

    setBlobs (blobs) {
      this.blobs = blobs
    }
  }
}
</script>

<style lang="postcss" scoped>
.ct-form {
  @apply bg-neutral-50
    drop-shadow-lg
    max-w-screen-md
    p-12;

  &__title {
    @apply space-y-3
      py-6
      border-b-2
      border-theme-blue
      mb-8
      text-subtext
      font-bold;
  }

  &__id,
  &__project-name {
    @apply font-bold
      text-black;
  }

  &__id {
    @apply text-h1;
  }

  &__project-name {
    @apply text-t1
      break-words;
  }

  &__container {
    @apply pb-4
      mb-6
      bg-theme-blueLight
      border-2
      border-theme-blue
      border-dashed
      p-12
      flex
      flex-col justify-center;
  }

  /* &--dragged-over {} @TODO: implement */

  &__header {
    @apply mb-8
      flex
      justify-between;

    &--item {
      @apply text-black;
    }
  }

  &__list-item {
    @apply flex
      justify-between
      items-center
      rounded
      py-6
      mb-4
      shadow-md
      shadow-slate-200;

    &--group {
      @apply flex
        items-center;
    }
  }

  &__icon-cloud {
    @apply h-16
      mb-6
      text-theme-blue;
  }

  &__icon {
    @apply h-16
      mb-6
      text-theme-blue;

    &-list {
      @apply mx-4
        my-0
        h-6
        w-6;
    }
  }

  &__file-label {
    @apply flex;
  }

  &__label {
    @apply text-t1
      font-bold
      text-center
      mb-6;
  }

  &__helper-text {
    @apply italic
      text-subtext
      mb-2;
  }

  &__input {
    @apply mb-6;
  }

  &__cta {
    @apply mt-10
      flex
      justify-evenly;
  }
}
</style>
