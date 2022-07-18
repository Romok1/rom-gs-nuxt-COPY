<template>
  <div class="ct-home">
    <Header image="/homepage_images/HeroBackgroundHome.png">
      <h1
        class="ct-home__header"
        v-text="translation_heroTitle"
      />
      <h3
        class="ct-home__sub-header"
        v-text="translation_heroSubtitle"
      />
    </Header>
    <Container>
      <Banner class="ct-home__banner">
        <template #text>
          <h4
            class="ct-home__banner__title"
            v-text="translation_bannerTitle"
          />
          <p
            class="ct-home__banner__description"
            v-text="translation_bannerText"
          />
        </template>
        <template #image>
          <img
            src="/homepage_images/MapHome.png"
            :alt="translation_bannerAltText"
          >
        </template>
      </Banner>
    </Container>
    <div class="ct-home__carousel">
      <Container>
        <CarouselBase :configuration="carouselConfiguration">
          <CarouselTile
            v-for="(tile, tileIndex) in carouselTiles"
            v-bind="tile"
            :key="tileIndex"
          />
        </CarouselBase>
      </Container>
    </div>
  </div>
</template>

<script>
import breakpoints from '~/tailwind/breakpoints.config'

export default {
  name: 'HomePage',

  auth: 'guest',

  layout: 'public',

  computed: {
    carouselConfiguration () {
      const breakpointMin = 0
      const breakpointMax = parseInt(breakpoints.lg.replace(/\D/g, ''))

      // @see https://github.com/jambonn/vue-concise-carousel#configuration
      return {
        perPageCustom: [
          [breakpointMin, 1],
          [breakpointMax, 2]
        ],
        scrollPerPage: false,
        spacePadding: 0
      }
    },

    carouselTiles () {
      return [
        {
          backgroundImage: '/homepage_images/carousel_image1.png',
          heading: 'Great Wetlands of the World',
          link: '#'
        },
        {
          backgroundImage: '/homepage_images/carousel_image2.png',
          heading: 'Patterns of Deforestation in the Colombian Amazon',
          link: '#'
        },
        {
          backgroundImage: '/homepage_images/carousel_image1.png',
          heading: 'Great Wetlands of the World',
          link: '#'
        },
        {
          backgroundImage: '/homepage_images/carousel_image2.png',
          heading: 'Patterns of Deforestation in the Colombian Amazon',
          link: '#'
        },
        {
          backgroundImage: '/homepage_images/carousel_image1.png',
          heading: 'Great Wetlands of the World',
          link: '#'
        },
        {
          backgroundImage: '/homepage_images/carousel_image2.png',
          heading: 'Patterns of Deforestation in the Colombian Amazon',
          link: '#'
        }
      ]
    },

    translation_heroTitle () {
      return this.$t('pages.home.hero.title')
    },

    translation_heroSubtitle () {
      return this.$t('pages.home.hero.subtitle')
    },

    translation_bannerText () {
      return this.$t('pages.home.banner.text')
    },

    translation_bannerTitle () {
      return this.$t('pages.home.banner.title')
    },

    translation_bannerAltText () {
      return this.$t('pages.home.banner.alt')
    }
  }
}
</script>
<style lang="postcss" scoped>
.ct-home {
  :deep(&__sub-header) {
    @apply text-subtext;
  }

  &__banner {
    @apply my-8
      lg:my-16;
  }

  :deep(&__banner__title) {
    @apply mb-6;
  }

  &__carousel {
    @apply bg-theme-blueLight
      py-8
      lg:py-16;

    &__slide {
      @apply w-[50vw]
        max-h-[400px];
    }
  }
}
</style>
