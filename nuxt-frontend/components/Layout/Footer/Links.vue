<template>
  <div class="ct-links">
    <ul class="ct-links__list">
      <li
        v-for="(link, linkIndex) in links"
        :key="linkIndex"
        class="ct-links__list-item"
      >
        <NuxtLink
          v-if="link.href.startsWith('/')"
          :to="localePath(link.href)"
          class="ct-links__link"
          v-text="/* eslint-disable-line vue/no-v-text-v-html-on-component */
            link.text
          "
        />
        <a
          v-else
          :href="link.href"
          class="ct-links__link"
          v-html="link.text"
        />
      </li>
    </ul>
    <div
      class="ct-links__copyright"
      v-html="$t('layout.footer.copyright', { currentYear })"
    />
  </div>
</template>

<script>
export default {
  computed: {
    currentYear () {
      return new Date().getFullYear()
    },

    links () {
      const links = this.$t('layout.footer.links')

      if (Array.isArray(links)) {
        return links
      }

      return []
    }
  }
}
</script>

<style lang="postcss" scoped>
.ct-links {
  @apply space-y-2
    text-s1;

  &__list {
    @apply flex
      items-center
      justify-center;
  }

  &__list-item:not(:first-child) {
    @apply border-l
      pl-2
      ml-2;
  }

  &__link {
    @apply text-theme-blue;
  }

  &__copyright {
    @apply opacity-80;
  }
}
</style>
