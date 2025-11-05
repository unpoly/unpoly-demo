// Remove notification flashes after a few seconds.

let seenFlashes = new Set()

up.compiler('.flash', function(flash, { nonce }) {
  if (nonce) {
    if (seenFlashes.has(nonce)) {
      // Remove a flash message that has already been shown
      flash.remove()
      return
    }
    // Remember that we've seen this flash message
    seenFlashes.add(nonce)

    // Only track the last 500 nonces
    if (seenFlashes.size > 500) {
      seenFlashes.delete(seenFlashes.values().next().value)
    }
  }

  up.animate(flash, 'move-from-right', { duration: 125 })
  up.util.timer(4000, () => up.destroy(flash, { animation: 'move-to-right' }))
})

window.showFlash = function(type, message) {
  let container = document.querySelector('[up-flashes]')
  let flash = up.element.affix(container, `.flash.-${type}`, { text: message })
  up.hello(flash)
}