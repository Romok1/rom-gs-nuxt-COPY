<script>
/**
 * SSR-friendly carousel
 * @see https://github.com/jambonn/vue-concise-carousel
 */
import { Carousel, Slide } from '@jambonn/vue-concise-carousel'
import '@jambonn/vue-concise-carousel/dist/vue-concise-carousel.css'

const DEFAULT_CONFIGURATION = {
  navigationEnabled: false,
  paginationActiveColor: '#469ddd',
  paginationColor: '#ffffff',
  paginationPadding: 0,
  paginationSize: 30
}

export default {
  components: {
    CtCarousel: Carousel,
    CtSlide: Slide
  },

  props: {
    configuration: {
      type: Object,
      default: () => ({})
    }
  },

  computed: {
    carouselConfiguration () {
      return {
        props: {
          ...DEFAULT_CONFIGURATION,
          ...this.configuration
        },
        ref: 'carousel',
        class: 'ct-carousel'
      }
    }
  },

  render (createElement) {
    const carouselSlides = [].concat(this.$slots.default).map(child => createElement('CtSlide', null, [child]))

    return createElement('CtCarousel', this.carouselConfiguration, carouselSlides)
  }
}
</script>

<style lang="postcss">
.ct-carousel {
  @apply -mx-3;

  /* stylelint-disable-next-line plugin/stylelint-bem-namics */
  .VueCarousel-pagination {
    @apply mt-9;
  }

  /* stylelint-disable-next-line plugin/stylelint-bem-namics */
  .VueCarousel-dot {
    @apply bg-white
      border
      border-solid
      border-theme-blue
      mx-2;

    /* stylelint-disable-next-line plugin/stylelint-bem-namics */
    &--active {
      @apply bg-theme-blue;
    }
  }
}
</style>
