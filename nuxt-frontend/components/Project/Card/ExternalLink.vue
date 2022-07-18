<template>
  <a href="#" target="_blank" class="text-black font-medium hover:text-gray-800 flex flex-nowrap space-x-2 align-center">
    <span><slot /></span>
    <IconExternal class="h-[1em] w-[1em] text-theme-blue" />
  </a>
</template>

<script>
export default {
  props: {
    to: {
      type: String,
      required: true
    }
  }
}
</script>
