//= require unpoly
//= require unpoly-bootstrap4

// Accelerate all links so the demo feels snappy.
// We still assign out [up-follow] manually so there's less magic for demo viewers.
up.link.config.instantSelectors.unshift('a[up-follow]')
up.link.config.preloadSelectors.unshift('a[up-follow]')

// Enable more logging for curious users.
up.log.enable()

// Gray out tour dots once clicked.
up.on('up:link:follow', '.tour-dot', (event, element) => { element.classList.add('viewed') })

// Don't highlight the fragment insertion from the initial compile on DOMContentLoaded.
window.addEventListener('load', (event) => {
  // Show the yellow flash when a new fragment was inserted.
  up.on('up:fragment:inserted', (event, fragment) => {
    fragment.classList.add('new-fragment', 'inserted')
    up.util.timer(0, () => fragment.classList.remove('inserted'))
    up.util.timer(1000, () => fragment.classList.remove('new-fragment'))
  })
})
