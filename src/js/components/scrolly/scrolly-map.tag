<sealevel-scrolly-map class="scrolly__map">

  <div id="scrolly__map" class="scrolly__map__container"></div>

  <sealevel-scrolly-map-animation
    if={state.animation.items && activeStep === 'world'}
    map={map} items={state.animation.items}
  />

  <script type="text/babel">
    import mapboxgl from 'mapbox-gl'
    import './scrolly-map-animation.tag'
    import { fetchAnimationDataIfNeeded } from '../../actions/animation'

    this.activeLayers = []
    this.state = this.store.getState()
    this.subscribe(state => this.update({ state }))

    this.on('update', () => {
      this.activeStep = this.state.navigation.activeStep
    })

    this.on('updated', () => {
      this.map && updateLayers(this.activeStep)
    })

    this.on('mount', () => {
      this.map = renderMap()
      this.store.dispatch(fetchAnimationDataIfNeeded())
    })

    const updateLayers = (activeStep) => {
      switch (activeStep) {

        case 'world':
          this.map.fitBounds([
            [-160, -55],
            [185.1, 75]
          ], { duration: 0 })
          break

        case 'manila':
          this.map.flyTo({
            center: [121, 14.65],
            zoom: 10,
            offset: [-200, 0]
          })
          break

        case 'scandinavia':
          this.map.fitBounds([
            [-25.18, 54.47],
            [32.82, 71.27]
          ], {
            offset: [200, 0]
          })
          break

        case 'france':
          this.map.flyTo({
            center: [3.93, 43.52],
            zoom: 5,
            offset: [-200, 0]
          })
          break

        case 'usa':
          this.map.flyTo({
            center: [-73.93, 40.52],
            zoom: 5,
            offset: [200, 0]
          })
          break

        case 'argentina':
          this.map.flyTo({
            center: [-58.38, -34.6],
            zoom: 5,
            offset: [-200, 0]
          })
          break
      }
    }

    const renderMap = () => {
      mapboxgl.accessToken = 'pk.eyJ1IjoiZmVsaXhtaWNoZWwiLCJhIjoiZWZrazRjOCJ9.62fkOEqGMxFxJZPJuo2iIQ'
      const map = new mapboxgl.Map({
        container: 'scrolly__map',
        style: 'mapbox://styles/felixmichel/cj1550ogw002s2smkgbz60keh',
        zoom: 3
      })

      map.on('load', () => {
        // set locale for map features
        const locale = this.i18n.getLocale()
        map.setLayoutProperty('place_label_city', 'text-field', `{name_${locale}}`)
        map.setLayoutProperty('place_label_other', 'text-field', `{name_${locale}}`)
        map.setLayoutProperty('country_label', 'text-field', `{name_${locale}}`)

        // disable map rotation using right click + drag
        map.dragRotate.disable()

        // disable map rotation using touch rotation gesture
        map.touchZoomRotate.disableRotation()

        // initial state
        updateLayers('world')
      })

      return map
    }

  </script>
</sealevel-scrolly-map>
