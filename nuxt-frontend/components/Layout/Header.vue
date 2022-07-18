<template>
  <div class="ct-header">
    <Container>
      <div class="ct-header__inner">
        <div class="ct-header__logo-group">
          <NuxtLink
            class="ct-header__logo-abbreviation"
            :to="localePath('/')"
            v-text="translation_titleAbbreviation"
          />
          <IconLogoUNEP class="h-full" />
          <IconLogoGEF class="h-full" />
        </div>

        <Tabs
          v-if="showTabs"
          v-model="tabSelected"
          class="ct-header__tabs"
          v-bind="{ tabs }"
        />
        <AccountDropdown />

        <div v-if="showAuthenticationButton">
          <TButton
            v-if="$auth.loggedIn"
            variant="secondary"
            @click="onLogoutButtonClick"
          >
            {{ $t('common.logout') }}
          </TButton>
          <TButton
            v-else
            :to="localePath('/login')"
          >
            {{ $t('common.login') }}
          </TButton>
        </div>
      </div>
    </Container>
  </div>
</template>

<script>
export default {
  props: {
    minimal: {
      type: Boolean,
      default: false
    }
  },

  data () {
    return {
      tabSelected: undefined,
      tabs: []
    }
  },

  computed: {
    showTabs () {
      return this.$auth.loggedIn
    },

    showAuthenticationButton () {
      return !this.$auth.loggedIn && !this.$route.path.endsWith('/login')
    },

    translation_titleAbbreviation () {
      return this.$t('app.titleAbbreviation')
    }
  },

  created () {
    const tabs = this.$t('components.layout.navigation.topbar.tabs')
    this.tabs = tabs
    this.tabSelected = tabs[0]
  },

  methods: {
    onLogoutButtonClick () {
      this.$auth.logout().then(() => {
        this.$router.push(this.localePath('/login'))
      })
    }
  }
}
</script>

<style lang="postcss" scoped>
.ct-header {
  @apply bg-white
    shadow-md
    z-10;

  &__inner {
    @apply flex
      h-24
      items-center
      justify-between;
  }

  &__logo-abbreviation {
    @apply font-bold
      text-t1
      text-theme-blue;
  }

  &__logo-group {
    @apply flex
      justify-center
      items-center
      space-x-6
      h-9;
  }

  &__logo-divider {
    @apply border
      border-l-black
      h-full;
  }

  &__tabs {
    @apply self-end;
  }
}
</style>
