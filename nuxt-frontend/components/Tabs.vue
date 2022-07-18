<template>
  <ul class="ct-tabs">
    <li v-for="(tab, tabIndex) in tabs" :key="tabIndex" class="ct-tabs__list">
      <NuxtLink
        class="ct-tabs__button"
        :class="{
          'ct-tabs__button--selected': isTabSelected(tab)
        }"
        v-bind="{ to: localePath(tab.to) }"
        @click="onButtonClick(tab)"
      >
        {{ tab.text }}
      </NuxtLink>
    </li>
  </ul>
</template>

<script>
export default {
  model: {
    event: 'change',
    prop: 'tabSelected'
  },

  props: {
    tabSelected: {
      type: Object,
      default: undefined
    },

    tabs: {
      type: Array,
      required: true,
      validator: tabs => tabs.every((tab) => {
        try {
          return [
            'text',
            'to'
          ].every(attr => Object.prototype.hasOwnProperty.call(tab, attr))
        } catch (e) {
          return false
        }
      })
    }
  },

  methods: {
    isTabSelected (tab) {
      return tab.to === this.tabSelected.to
    },

    onButtonClick (tab) {
      this.$emit('change', tab)
    }
  }
}
</script>

<style lang="postcss" scoped>
.ct-tabs {
  @apply flex;

  &__list {
    @apply flex;
  }

  &__button {
    @apply py-5
      px-7
      border-b-4
      border-transparent
      text-t1
      focus:border-theme-blueDark
      hover:border-theme-blueLight
      active:border-theme-blueDark;
  }
}

a.nuxt-link-active {
  @apply border-theme-blue
    font-bold;
}
</style>
