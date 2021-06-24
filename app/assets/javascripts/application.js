//= require unpoly
//= require unpoly-bootstrap4

// Accelerate all links so the demo feels snappy.
// We still assign out [up-follow] manually so there's less magic for demo viewers.
up.link.config.instantSelectors.unshift('a')
up.link.config.preloadSelectors.unshift('a[href]')

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

// Show a loading indicator above the nav bar if a request takes long to load
up.compiler('loading-indicator', (element) => {
  let timeout = undefined
  let transitionDelay = 300

  function move() {
    let step = 0
    let width = 33

    function moveNext() {
      step++
      if (width < 90) width++
      moveTo(width)
      timeout = setTimeout(moveNext, transitionDelay + step * 30)
    }
    moveNext()
  }

  function moveTo(width) {
    element.style.width = `${width}vw`
  }

  function finish() {
    clearTimeout(timeout)
    moveTo(100)
  }

  function show() {
    element.classList.add('visible')
    element.style.transition = `width ${transitionDelay}ms ease-out`
  }

  function hide() {
    element.style.transition = `width 0 ease-out`
    element.classList.remove('visible')
    moveTo(0)
  }

  function onLate() {
    show()
    move()
  }

  function onRecover() {
    finish()
    setTimeout(hide, transitionDelay)
  }

  return [
    up.on('up:request:late', onLate),
    up.on('up:request:recover', onRecover),
  ]
})
