//= require unpoly
//= require unpoly-bootstrap5

// Accelerate all links so the demo feels snappy.
// We still assign out [up-follow] manually so there's less magic for demo viewers.
up.link.config.instantSelectors.unshift('a[href]')
up.link.config.preloadSelectors.unshift('a[href]')

up.form.config.groupSelectors.unshift('.form-group')

// Enable more logging for curious users.
up.log.enable()

// Gray out tour dots once clicked.
up.on('up:link:follow', '.tour-dot', (event, element) => { element.classList.add('viewed') })

// Don't highlight the fragment insertion from the initial compile on DOMContentLoaded.
window.addEventListener('load', () => {
  // Show the yellow flash when a new fragment was inserted.
  up.on('up:fragment:inserted', (event, fragment) => {
    if (fragment.matches('.fragment-explainer, [up-flashes], .btn-spinner')) return
    if (fragment.querySelector('.placeholder')) return
    showInsertedFlash(fragment)
  })
})

window.showInsertedFlash = function(fragment) {
  fragment = up.fragment.get(fragment)

  if (fragment.matches('up-modal, up-modal main')) fragment = fragment.closest('up-modal').querySelector('up-modal-box')
  if (fragment.matches('up-drawer, up-drawer main')) fragment = fragment.closest('up-drawer').querySelector('up-drawer-box')
  if (fragment.matches('up-popup, up-popup main')) fragment = fragment.closest('up-popup').querySelector('up-popup-box')

  fragment.classList.add('new-fragment', 'inserted')
  up.util.timer(0, () => fragment.classList.remove('inserted'))
  up.util.timer(750, () => fragment.classList.remove('new-fragment'))
}

// Prompt user to reload when frontend assets changeds on the server.
up.on('up:assets:changed', function() {
  up.element.show(document.querySelector('#new-version'))
})

// Remove notification flashes after a few seconds.
up.compiler('.alert', function(alert) {
  up.util.timer(4000, () => up.destroy(alert, { animation: 'move-to-top' }))
})

up.on('up:link:follow', '.table a[up-layer*=new]', ({ renderOptions }) => {
  renderOptions.skeleton = '#form-skeleton'
})

up.preview('btn-spinner', function(preview) {
  preview.insert(preview.origin, 'afterbegin', '<span class="btn-spinner"></span>')
})

up.fragment.config.navigateOptions.cache = false

up.compiler('.rtt', (fragment, _data, { response }) => {
  let { rtt, request } = response
  let { fromCache } = request

  let info = `${rtt} ms`
  if (fromCache) {
    info += ' <span class="text-muted">(cache)</span>'
  }

  fragment.innerHTML = info
})
