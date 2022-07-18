<template>
  <div class="ct-default">
    <PortalTarget name="modal" />
    <div class="ct-default__container">
      <LayoutHeader class="ct-default__header" minimal />
      <div class="ct-default__body">
        <Nuxt />
      </div>
      <LayoutFooter class="ct-default__footer">
        <Container class="ct-default__footer-container">
          <LayoutFooterLinks class="ct-default__footer-links" />
        </Container>
      </LayoutFooter>
    </div>
  </div>
</template>

<script>
export default {
  name: 'LayoutDefault'
}
</script>

<style lang="postcss" scoped>
.ct-default {
  @apply flex flex-col min-h-screen;

  &__container {
    @apply flex-auto;

    display: grid;
    grid-template:
      "header header header" min-content
      "body body body" 1fr
      "footer footer footer" min-content / 1fr 1fr 1fr;
  }

  &__header {
    grid-area: header;
  }

  &__body {
    @apply flex justify-center;

    grid-area: body;
  }

  &__footer {
    grid-area: footer;

    &-links {
      @apply text-center;
    }
  }
}
</style>
