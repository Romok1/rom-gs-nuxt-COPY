<template>
  <div
    class="relative text-white bg-center bg-cover group w-full h-64"
    :style="{ backgroundImage: `url('${image}')` }"
  >
    <div
      class="
        group-hover:bg-neutral-700/50
        h-full
        w-full
        flex
        text-center
        items-center
        justify-center
        transition-all
        ease-in-out
      "
    >
      <div class="group-hover:hidden">
        <slot />
      </div>
      <div class="hidden group-hover:block">
        <slot name="overlay" />
      </div>
    </div>
  </div>
</template>

<script>
export default {
  props: {
    image: {
      type: String,
      required: true
    }
  }
}
</script>
