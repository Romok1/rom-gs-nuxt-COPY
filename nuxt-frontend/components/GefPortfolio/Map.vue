<template>
  <ClientOnly>
    <MglMap
      class="ct-map"
      :access-token="accessToken"
      :map-style="mapStyle"
      :center.sync="center"
      :zoom.sync="zoom"
      :transform-request="transformRequest"
      @load="onMapLoaded"
    >
      <MglGeojsonLayer
        v-bind="geojsonBaseLayerPolygons"
        @click="onPolygonLayerClick"
      />
      <MglGeojsonLayer v-bind="geojsonBaseLayer" />
      <MglGeojsonLayer
        :source-id="GEF_PROJECTS_SOURCE_ID"
        :layer-id="LAYER_ID_CLUSTER_COUNT"
        :layer="layers_clusterCount"
        @click="onClusterCountLayerClick"
      />
      <MglGeojsonLayer
        :source-id="GEF_PROJECTS_SOURCE_ID"
        :layer-id="LAYER_ID_UNCLUSTERED_POINT"
        :layer="layers_unclusteredPoint"
        @click="onUnclusteredPointLayerClick"
      />
      <MglNavigationControl
        position="bottom-left"
        :show-compass="false"
      />
    </MglMap>
  </ClientOnly>
</template>

<script>
import Mapbox from 'mapbox-gl'
import themeColors from '~/tailwind/colors.config'

const CLUSTER_MAX_ZOOM_LEVEL = 14
const CLUSTER_RADIUS = 50
const GEF_PROJECTS_POLYGONS_SOURCE_ID = 'gef-projects-polygons'
const GEF_PROJECTS_SOURCE_ID = 'gef-projects'
const LAYER_ID_CLUSTER_COUNT = 'cluster-count'
const LAYER_ID_CLUSTERS = 'clusters'
const LAYER_ID_POLYGON = 'polygon'
const LAYER_ID_UNCLUSTERED_POINT = 'unclustered-point'
const MAP_CENTER_DEFAULT = [-103.5917, 40.6699]
const MAP_ZOOM_DEFAULT = 0
const POLYGON_ZOOM_LEVEL = 3.5

const setVisibility = show => show ? 'visible' : 'none'

export default {
  data () {
    return {
      accessToken: undefined,
      mapStyle: undefined,
      zoom: MAP_ZOOM_DEFAULT,
      center: MAP_CENTER_DEFAULT,
      toggleShowPolygons: false
    }
  },

  head () {
    return {
      link: [
        {
          rel: 'stylesheet',
          href: 'https://api.mapbox.com/mapbox-gl-js/v2.8.2/mapbox-gl.css'
        }
      ]
    }
  },

  computed: {
    CLUSTER_MAX_ZOOM_LEVEL: () => CLUSTER_MAX_ZOOM_LEVEL,
    CLUSTER_RADIUS: () => CLUSTER_RADIUS,
    GEF_PROJECTS_POLYGONS_SOURCE_ID: () => GEF_PROJECTS_POLYGONS_SOURCE_ID,
    GEF_PROJECTS_SOURCE_ID: () => GEF_PROJECTS_SOURCE_ID,
    LAYER_ID_CLUSTER_COUNT: () => LAYER_ID_CLUSTER_COUNT,
    LAYER_ID_CLUSTERS: () => LAYER_ID_CLUSTERS,
    LAYER_ID_POLYGON: () => LAYER_ID_POLYGON,
    LAYER_ID_UNCLUSTERED_POINT: () => LAYER_ID_UNCLUSTERED_POINT,
    MAP_CENTER_DEFAULT: () => MAP_CENTER_DEFAULT,
    MAP_ZOOM_DEFAULT: () => MAP_ZOOM_DEFAULT,
    POLYGON_ZOOM_LEVEL: () => POLYGON_ZOOM_LEVEL,

    geojson () {
      return this.$store.getters['portfolio/chart/geojson']
    },

    geojsonPolygons () {
      return this.$store.getters['portfolio/chart/geojsonPolygons']
    },

    geojsonBaseLayer () {
      return {
        sourceId: GEF_PROJECTS_SOURCE_ID,
        source: {
          type: 'geojson',
          data: this.geojson,
          cluster: true,
          clusterMaxZoom: CLUSTER_MAX_ZOOM_LEVEL, // Max zoom to cluster points on
          clusterRadius: CLUSTER_RADIUS // Radius of each cluster when clustering points (defaults to 50)
        },
        layerId: this.layers_clusters.id,
        layer: this.layers_clusters
      }
    },

    geojsonBaseLayerPolygons () {
      return {
        sourceId: GEF_PROJECTS_POLYGONS_SOURCE_ID,
        source: {
          type: 'geojson',
          data: this.geojsonPolygons
          // @TODO: rework map to query geoserver directly
          // data: this.geoserverPolygonUrl
        },
        layerId: this.layers_polygon.id,
        layer: this.layers_polygon
      }
    },

    // @TODO: rework map to query geoserver directly
    geoserverPolygonUrl () {
      if (this.map) {
        const {
          owsEndpoint,
          remoteHost
        } = this.$config.geoserver

        const bbox = [
          this.map.getBounds().getSouthWest().lat,
          this.map.getBounds().getSouthWest().lng,
          this.map.getBounds().getNorthEast().lat,
          this.map.getBounds().getNorthEast().lng
        ]

        const url = this.$axios.getUri({
          url: `https://${remoteHost}${owsEndpoint}`,
          params: {
            service: 'WFS',
            version: '1.0.0',
            request: 'GetFeature',
            typeName: 'grip:project_geoms',
            outputFormat: 'application/json',
            bbox: bbox.join(',')
          }
        })

        return url
      }

      return null
    },

    layers_clusters () {
      return {
        id: LAYER_ID_CLUSTERS,
        type: 'circle',
        source: GEF_PROJECTS_SOURCE_ID,
        filter: ['has', 'point_count'],
        paint: {
          'circle-color': themeColors.red,
          'circle-radius': [
            'step',
            ['get', 'point_count'],
            20,
            100,
            30,
            750,
            40
          ]
        }
      }
    },

    layers_clusterCount () {
      return {
        id: LAYER_ID_CLUSTER_COUNT,
        type: 'symbol',
        source: GEF_PROJECTS_SOURCE_ID,
        filter: ['has', 'point_count'],
        layout: {
          'text-field': '{point_count_abbreviated}',
          'text-font': ['DIN Offc Pro Medium', 'Arial Unicode MS Bold'],
          'text-size': 14
        },
        paint: {
          'text-color': '#fff'
        }
      }
    },

    layers_unclusteredPoint () {
      return {
        id: LAYER_ID_UNCLUSTERED_POINT,
        type: 'circle',
        source: GEF_PROJECTS_SOURCE_ID,
        filter: ['!', ['has', 'point_count']],
        paint: {
          'circle-color': themeColors.red,
          'circle-radius': 5
          // 'circle-stroke-width': 0,
          // 'circle-stroke-color': '#fff'
        }
      }
    },

    layers_polygon () {
      return {
        id: LAYER_ID_POLYGON,
        type: 'fill',
        source: GEF_PROJECTS_POLYGONS_SOURCE_ID,
        paint: {
          'fill-color': themeColors.red,
          'fill-opacity': 0.75
        }
      }
    },

    showPolygons () {
      return this.zoom >= POLYGON_ZOOM_LEVEL || this.toggleShowPolygons
    },

    // @TODO: rework map to query geoserver directly
    basicAuthenticationString () {
      const { user, password } = this.$config.geoserver.basicAuth
      const base64Credentials = window.btoa(`${user}:${password}`)

      return `Basic ${base64Credentials}`
    },

    // @TODO: rework map to query geoserver directly
    transformRequest () {
      const remoteHost = this.$config.geoserver.remoteHost

      return (url, resourceType) => {
        const startsWithRemoteHost = new RegExp(`^https?://${remoteHost}`).test(url)

        if (resourceType === 'Source' && startsWithRemoteHost) {
          return {
            headers: {
              Authorization: this.basicAuthenticationString
            },
            // Include cookies for cross-origin requests.
            credentials: 'include'
          }
        }
      }
    }
  },

  watch: {
    geojson (geojson) {
      if (typeof geojson === 'object' && geojson !== null) {
        if (geojson.features.length === 1) {
          const feature = geojson.features[0]

          this.map.flyTo({
            center: feature.geometry.coordinates,
            // This animation is considered essential with respect to prefers-reduced-motion
            essential: true
          })
        } else {
          const bounds = new this.mapbox.LngLatBounds()

          geojson.features.forEach(feature => bounds.extend(feature.geometry.coordinates))

          this.map.fitBounds(bounds, { padding: 100 })
        }
      }
    },

    showPolygons (showPolygons, prevShowPolygons) {
      if (showPolygons !== prevShowPolygons) {
        this.togglePolygonLayer(showPolygons)
      }
    }
  },

  created () {
    this.accessToken = this.$config.mapbox.accessToken
    this.mapStyle = this.$config.mapbox.mapStyle

    this.map = null
    this.mapbox = Mapbox
  },

  methods: {
    markerRef (markerId) {
      return `marker__${markerId}`
    },

    onMapLoaded (e) {
      this.map = e.map

      this.zoom = MAP_ZOOM_DEFAULT

      const clickableLayers = [
        LAYER_ID_CLUSTERS,
        LAYER_ID_POLYGON,
        LAYER_ID_UNCLUSTERED_POINT
      ]

      clickableLayers.forEach((layer) => {
        this.map.on('mouseenter', layer, () => {
          this.map.getCanvas().style.cursor = 'pointer'
        })

        this.map.on('mouseleave', layer, () => {
          this.map.getCanvas().style.cursor = ''
        })
      })

      this.$nextTick(() => {
        this.togglePolygonLayer(false)
      })
    },

    onClusterCountLayerClick (e) {
      const { map, mapboxEvent } = e
      const features = map.queryRenderedFeatures(mapboxEvent.point, {
        layers: [LAYER_ID_CLUSTERS]
      })
      const feature = features[0]
      const clusterId = feature.properties.cluster_id

      map.getSource(GEF_PROJECTS_SOURCE_ID).getClusterExpansionZoom(
        clusterId,
        (err, zoom) => {
          if (err) { return }

          map.easeTo({
            center: feature.geometry.coordinates,
            zoom
          })
        }
      )
    },

    onPolygonLayerClick (_e) {
      this.toggleShowPolygons = !this.toggleShowPolygons
    },

    onUnclusteredPointLayerClick (e) {
      const { mapboxEvent } = e

      this.map.flyTo({
        center: mapboxEvent.lngLat,
        // This animation is considered essential with respect to prefers-reduced-motion
        essential: true,
        zoom: this.zoom + 1
      })
    },

    togglePolygonLayer (showPolygonLayer) {
      this.map.setLayoutProperty(LAYER_ID_POLYGON, 'visibility', setVisibility(showPolygonLayer))

      const showPointLayers = !showPolygonLayer

      this.map.setLayoutProperty(LAYER_ID_CLUSTER_COUNT, 'visibility', setVisibility(showPointLayers))
      this.map.setLayoutProperty(LAYER_ID_CLUSTERS, 'visibility', setVisibility(showPointLayers))
      this.map.setLayoutProperty(LAYER_ID_UNCLUSTERED_POINT, 'visibility', setVisibility(showPointLayers))
    }
  }
}
</script>
