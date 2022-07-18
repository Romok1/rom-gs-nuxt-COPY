<template>
  <div class="ct-public">
    <PortalTarget name="modal" />
    <div class="ct-public__container">
      <LayoutHeader class="ct-public__header" />
      <div class="ct-public__body">
        <Nuxt />
      </div>
      <LayoutFooter class="ct-public__footer">
        <Container class="ct-public__footer-container">
          <div class="ct-public__footer-buttons">
            <TButton
              v-if="showAuthenticationButton"
              :to="localePath('/login')"
            >
              {{ $t('common.login') }}
            </TButton>
          </div>
          <LayoutFooterLinks class="ct-public__footer-links" />
        </Container>
      </LayoutFooter>
    </div>
  </div>
</template>

<script>
export default {
  name: 'LayoutPublic',

  computed: {
    showAuthenticationButton () {
      return !this.$auth.loggedIn && !this.$route.path.endsWith('/login')
    }
  }
}
</script>

<style lang="postcss" scoped>
.ct-public {
  &__container {
    @apply flex flex-col min-h-screen;
  }

  &__header {
    @apply bg-white;
  }

  &__body {
    @apply flex-1 bg-white;
  }

  &__footer {
    @apply bg-theme-blue space-y-4;

    :deep(&-container) {
      @apply space-y-4;
    }

    &-links {
      @apply text-right;

      :deep(.ct-links) {
        /* stylelint-disable-next-line plugin/stylelint-bem-namics */
        &__list {
          @apply justify-end text-white;
        }

        /* stylelint-disable-next-line plugin/stylelint-bem-namics */
        &__link {
          @apply text-white;
        }

        /* stylelint-disable-next-line plugin/stylelint-bem-namics */
        &__copyright {
          @apply text-neutral-50;
        }
      }
    }

    &-buttons {
      @apply flex justify-end;
    }
  }
}
</style>
