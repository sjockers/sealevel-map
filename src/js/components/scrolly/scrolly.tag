<sealevel-scrolly>

  <sealevel-scrolly-intro active={introActive} />

  <article class="scrolly__article" ref="article" />

  <nav class="scrolly__nav" data-gumshoe-header>
    <ul data-gumshoe>
      <li each={ steps }>
        <a href="#{ id }">{ title }</a>
      </li>
    </ul>
  </nav>

  <script type="text/babel">
    import route from 'riot-route'
    import _ from 'lodash'
    import gumshoe from 'gumshoe'
    import './scrolly-intro.tag'
    import { STEPS } from '../../routes/'
    import { setStep } from '../../actions/navigation'
    import content from '../../../en.md'

    const getSteps = (article) => {
      return _.map(article.querySelectorAll('[id]'), element => ({
        id: element.id,
        title: element.textContent
      }))
    }

    this.on('mount', () => {
      this.refs.article.innerHTML = content
      this.steps = getSteps(this.refs.article)
    })

    this.on('route', () => {
      gumshoe.init({
        container: window,
        callback: ({ target }) => {
          const activeStep = target.id
          if (activeStep !== this.activeStep) {
            this.update({ activeStep })
          }
        }
      })
    })

    this.on('update', update => {
      if (this.activeStep) {
        route(this.activeStep)
      }
    })

    // initialize routes for main navigation:
    _.forEach(STEPS, slug => {
      route(slug, () => {
        console.log('show step', slug)
        this.store.dispatch(setStep(slug))
        this.update({ introActive: false })
      })
    })

    route('/', () => {
      this.update({ introActive: true })
    })

    route.exec()

  </script>

</sealevel-scrolly>