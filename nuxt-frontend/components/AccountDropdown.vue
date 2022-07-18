<template>
  <div
    v-if="user"
    class="ct-account-dropdown"
  >
    <TAccountDropdown :show.sync="isShown">
      <template
        #trigger="{
          mousedownHandler,
          focusHandler,
          blurHandler,
          keydownHandler
        }"
      >
        <div class="ct-account-dropdown__trigger">
          <div
            class="ct-account-dropdown__avatar"
            v-text="user.initials"
          />
          <button
            :aria-label="translation_triggerLabel"
            aria-haspopup="true"
            class="ct-account-dropdown__button"
            @mousedown="mousedownHandler"
            @focus="focusHandler"
            @blur="blurHandler"
            @keydown="keydownHandler"
          >
            <IconChevronRight
              class="ct-account-dropdown__icon"
              :class="{
                'ct-account-dropdown__icon--active': isShown
              }"
            />
          </button>
        </div>
      </template>

      <div class="ct-account-dropdown__dropdown">
        <ul class="ct-account-dropdown__list">
          <li class="ct-account-dropdown__item">
            <button
              class="ct-account-dropdown__link"
              role="menuitem"
              @click="onLogoutButtonClick"
              v-text="translation_navigationLogoutText"
            />
          </li>
          <li
            v-for="(link, linkIndex) in navigation"
            :key="linkIndex"
            class="ct-account-dropdown__item"
          >
            <NuxtLink
              class="ct-account-dropdown__link"
              :to="localePath(link.to)"
              role="menuitem"
              @click="onLinkClick"
              v-text="link.text"
            />
          </li>
        </ul>
      </div>
    </TAccountDropdown>
  </div>
</template>

<script>
export default {
  data () {
    return {
      isShown: false
    }
  },

  computed: {
    navigation () {
      return this.$t('components.accountDropdown.navigation')
    },

    translation_navigationLogoutText () {
      return this.$t('components.accountDropdown.navigationLogoutLink.text')
    },

    translation_triggerLabel () {
      return this.$t('components.accountDropdown.triggerLabel')
    },

    user () {
      if (this.$auth.loggedIn) {
        const user = this.$auth.user

        return {
          ...user,
          initials: user.name.split(' ').map(part => part[0]).join(' ')
        }
      }

      return null
    }
  },

  methods: {
    setIsShown (isShown) {
      this.isShown = isShown === true
    },

    onLinkClick () {
      this.setIsShown(false)
    },

    onLogoutButtonClick () {
      this.setIsShown(false)
      return this.$auth.logout()
    },

    onTriggerClick () {
      this.setIsShown(!this.isShown)
    }
  }
}
</script>

<style lang="postcss" scoped>
.ct-account-dropdown {
  @apply flex;

  &__trigger {
    @apply flex
      items-center
      flex-nowrap
      space-x-2;
  }

  &__avatar {
    @apply rounded-full
      text-white
      text-t1
      font-bold
      bg-theme-blue
      p-5;
  }

  &__button {
    @apply p-4
      rounded-full
      hover:bg-gray-200;
  }

  &__icon {
    @apply w-4
      transition-all
      rotate-90
      text-theme-blue
      hover:text-theme-blueDark;

    &--active {
      @apply -rotate-90;
    }
  }

  &__link {
    @apply py-3
      px-4
      text-t1
      text-black;
  }
}
</style>
