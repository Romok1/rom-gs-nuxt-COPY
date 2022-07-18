<template>
  <ul class="ct-filelist">
    <li
      v-for="blob in blobs"
      :key="blob.signedId"
      class="ct-filelist__item"
    >
      <div class="ct-filelist__container">
        <IconPaperClip v-if="hasSignedId(blob)" class="ct-filelist__icon" />
        <IconLoading v-else class="ct-filelist__icon--busy" />
        <span class="ct-filelist__file-name" v-text="blob.filename" />
      </div>
      <div class="ct-filelist__container">
        <ProjectCardPill
          v-if="hasSignedId(blob)"
          class="ct-filelist__pill"
          v-bind="{ statusType: 'success'}"
          v-text="translation_pill"
        />
        <button
          v-show="hasSignedId(blob)"
          class="ct-filelist__icon ct-filelist__icon--close"
          @click="onDelete(blob)"
        >
          <IconClose />
        </button>
      </div>
    </li>
  </ul>
</template>

<script>
export default {
  props: {
    blobs: {
      type: Array,
      default: () => []
    }
  },

  computed: {
    translation_pill () {
      return this.$t('components.project.shapefileUpload.pill')
    }
  },

  methods: {
    hasSignedId (blob) {
      return Object.prototype.hasOwnProperty.call(blob, 'signedId') === true
    },

    onDelete ({ signedId }) {
      this.$emit(
        'change',
        this.blobs.filter(blob => blob.signedId !== signedId)
      )
    }
  }
}
</script>

<style lang="postcss" scoped>
.ct-filelist {
  @apply space-y-4;

  &__item {
    @apply flex
      justify-between
      items-center
      rounded-md
      py-6
      px-4
      space-x-3
      shadow-md
      shadow-slate-200;

    &--group {
      @apply flex
        items-center;
    }
  }

  &__icon {
    @apply h-6
      text-theme-blue;

    &--close,
    &--busy {
      @apply mx-4
        my-0
        h-6
        w-6;
    }

    &--busy {
      @apply animate-spin;
    }
  }

  &__container {
    @apply flex
      items-center
      text-t1
      font-bold
      self-center;
  }

  &__file-name {
    @apply ml-4;
  }

  &__input {
    @apply mb-6;
  }
}
</style>
