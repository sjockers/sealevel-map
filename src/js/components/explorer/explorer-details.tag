<sealevel-explorer-details>

  <a href={ opts.pathToCountry(opts.locale, opts.station.country) }>
    { opts.station.country }
  </a>

  <div class="details__close" onclick={ opts.onBack }>&#10006;</div>

  <h1 class="details__titel">{ opts.station.location }</h1>

  <p>{ opts.station.country }</p>

  <sealevel-linechart chartdata="{ this.opts.station.tideData }"></sealevel-linechart>

  <h4>Additional Information on { opts.station.Country }</h4>

  <p>CO2 emissions: <b>{ opts.station.emission.toFixed(2) } tons per capita</b></p>

  <p>GDP: <b>{ (opts.station.gdp / 1000000000).toLocaleString('en-US', { maximumSignificantDigits: 3 }) } bn US Dollars</b></p>

  <p>Population: <b>{ (opts.station.pop).toLocaleString('en-US', { maximumSignificantDigits: 3 }) }</b></p>

  <p>People living in coastal areas: <b>{ opts.station.pop_sealevel.toFixed(1) } % of population</b></p>

  <script type="text/babel">
    import '../linechart.tag'

    this.on('update', () => {
      if (this.opts.station) {
        const getYear = new Date(this.opts.station.tideData[0].timestamp)
        this.year = getYear.getFullYear()

        this.rise = opts.station.trend > 0 ? 'Rise of ' : 'Fall of '
      }
    })
  </script>

</sealevel-explorer-details>