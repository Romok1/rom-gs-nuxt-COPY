<template>
  <div class="ct-filter">
    <TRichSelect
      v-bind="{
        clearable: true,
        closeOnSelect: false,
        multiple: true,
        options,
        textAttribute: 'name',
        valueAttribute: 'id',
        value: initialValue,
        ...configuration
      }"
      @input="onInput"
      @focus="onFocus"
      @blur="onBlur"
      @fetch-error="onFetchError"
      @click="onClick"
    >
      <template #arrow="{ className }">
        <IconChevronRight
          :class="[
            className,
            {
              'ct-filter__dropdown-icon--active': focus
            }
          ]"
          class="ct-filter__dropdown-icon"
        />
      </template>
      <template #noResults>
        <div
          class="ct-filter__noResults"
          v-text="translation_noResults"
        />
      </template>
      <template #loadingMoreResultsText>
        <IconLoading class="ct-filter__loading" />
      </template>
    </TRichSelect>
  </div>
</template>

<script>
import { duplicate } from '~/functions/duplicate'

export default {
  props: {
    configuration: {
      type: Object,
      default: () => ({})
    },

    options: {
      type: Array,
      required: true
    },

    value: undefined
  },

  data () {
    return {
      initialValue: [],
      focus: false
    }
  },

  computed: {
    isMultiple () {
      return !(this.configuration.multiple === false)
    },

    translation_noResults () {
      return this.$t('common.noResults')
    }
  },

  created () {
    const value = duplicate(this.value)

    this.initialValue = this.isMultiple ? [].concat(value) : value
  },

  methods: {
    onInput (value) {
      if (this.isMultiple) {
        const values = [].concat(value).filter(value => value)

        this.$emit('change', values)
      } else {
        this.$emit('change', value)
      }
    },

    onFocus (e) {
      this.setFocus(true)
      this.$emit('focus', e)
    },

    onBlur (e) {
      this.setFocus(false)
      this.$emit('blur', e)
    },

    onFetchError (e) {
      this.$emit('fetch-error', e)
    },

    onClick (e) {
      this.$emit('click', e)
    },

    setFocus (focus) {
      this.focus = focus === true
    }
  }
}
</script>

<style lang="postcss" scoped>
.ct-filter {
  &__dropdown-icon {
    @apply inline-block
      transition-transform
      ease-in-out
      rotate-90;

    &--active {
      @apply -rotate-90;
    }
  }

  &__loading {
    @apply h-6
      w-6
      animate-spin;
  }
}
</style>
