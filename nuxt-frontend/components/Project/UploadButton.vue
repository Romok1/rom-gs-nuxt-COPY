<template>
  <button class="ct-button">
    <div
      class="ct-button__container"
    >
      <NuxtLink
        class="ct-button__button"
        :to="localePath(`/gef-projects-shapefile/${gefId}`)"
      >
        <IconEdit class="ct-button__icon" />
        <span
          class="ct-button__text"
          v-text="$t('project.card.buttons.edit')"
        />
      </NuxtLink>
    </div>
  </button>
</template>

<script>
export default {
  inject: [
    'id',
    'gefId',
    'shapefile'
  ]
}
</script>

<style lang="postcss" scoped>
.ct-button {
  @apply text-t1
    mb-6;

  &__button {
    @apply flex;
  }

  &__icon {
    @apply w-7
      h-7
      pr-2
      text-theme-blueDark;
  }

  &__text {
    @apply text-t1
      text-theme-blueDark
      hover:text-theme-blue;
  }
}
</style>
