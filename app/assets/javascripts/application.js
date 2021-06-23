//= require unpoly
//= require unpoly-bootstrap4

up.link.config.instantSelectors.unshift('a')
up.link.config.preloadSelectors.unshift('a[href]')

up.log.enable()

up.on('up:link:follow', '.tour-dot', (event, element) => { element.classList.add('viewed') })

up.on('up:fragment:inserted', (event, fragment) => {
  fragment.classList.add('new-fragment', 'inserted')
  up.util.timer(0, () => fragment.classList.remove('inserted'))
  up.util.timer(1000, () => fragment.classList.remove('new-fragment'))
})
