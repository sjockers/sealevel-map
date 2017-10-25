<sealevel-scrolly-map-animation>

  <svg ref="vis" />

  <div class="container">
    <span class="scrolly__map-animation__counter">
      { year }
    </span>
  </div>

  <script type="text/babel">
    import * as d3 from 'd3'

    const MIN_YEAR = 1985
    const MAX_YEAR = 2015
    const ANIMATION_INTERVAL = 500
    const MAX_HEIGHT = 200

    this.on('mount', () => {
      initialize(this.opts.map)
    })

    this.on('unmount', () => {
      stopAnimation()
    })

    this.on('updated', () => {
      redraw()
    })

    const initialize = (map) => {
      const svg = d3.select(this.refs.vis)

      this.stations = this.opts.items

      if (this.stations.length > 0) {
        this.paths = svg.selectAll('path')
          .data(this.stations)
          .enter()
          .append('path')

        const domain = getDomainValues(this.stations)
        this.scale = d3.scaleLinear().rangeRound([MAX_HEIGHT, 0]).domain(domain)

        // initial rendering
        startAnimation()

        // re-render our visualization whenever the view changes
        map.on('viewreset', redraw)
        map.on('move', redraw)
      }
    }

    const startAnimation = () => {
      this.year = MIN_YEAR

      this.animationLoop = setInterval(() => {
        this.update({ year: ++this.year })
        if (this.year >= MAX_YEAR) stopAnimation()
      }, ANIMATION_INTERVAL)
    }

    const stopAnimation = () => {
      clearInterval(this.animationLoop)
    }

    function getDomainValues (items) {
      let yMin = d3.min(items, (station) => {
        return d3.min(station.timeseries)
      })

      let yMax = d3.max(items, (station) => {
        return d3.max(station.timeseries)
      })

      return [yMin, yMax]
    }

    const redraw = () => {
      const d3Projection = getD3Projection(this.opts.map)
      const path = d3.geoPath()
      path.projection(d3Projection)

      this.paths
        .transition(ANIMATION_INTERVAL)
        .attr('transform', (station) => {
          const year = this.year
          const point = d3Projection(station.lngLat)
          const tide = station.timeseries[year] || 0
          const triangleHeight = Math.abs(this.scale(tide) - this.scale(0))
          const x = point[0] - 3
          const y = tide <= 0 ? point[1] : point[1] - triangleHeight

          return `translate(${x}, ${y})`
        })
        .attr('d', (station) => {
          const tide = station.timeseries[this.year]
          const triangleHeight = Math.abs(this.scale(tide) - this.scale(0))

          if (tide) {
            return tide >= 0
              ? `M 3,0 6, ${triangleHeight} 0, ${triangleHeight} z`
              : `M 0 0 L 3 ${triangleHeight} L 6 0 z`
          } else {
            return 'M 0 0 L 3 0 L 6 0 z'
          }
        })
        .attr('class', (station) => {
          return station.timeseries[this.year] < 0
            ? 'scrolly__map-animation__item--negative'
            : 'scrolly__map-animation__item--positive'
        })
    }

    // map projection between map and vis
    // adapted from http://bl.ocks.org/enjalot/0d87f32a1ccb9a720d29ba74142ba365
    const getD3Projection = (map) => {
      var bbox = map.getCanvas().getBoundingClientRect()
      var center = map.getCenter()
      var zoom = map.getZoom()

      // 512 is hardcoded tile size, might need to be 256 or changed to suit your map config
      var scale = (512) * 0.5 / Math.PI * Math.pow(2, zoom)

      var d3projection = d3.geoMercator()
        .center([center.lng, center.lat])
        .translate([bbox.width / 2, bbox.height / 2])
        .scale(scale)

      return d3projection
    }

  </script>
</sealevel-scrolly-map-animation>
