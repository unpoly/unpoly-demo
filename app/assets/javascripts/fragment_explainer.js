up.compiler('.fragment-explainer', function(container) {
  let lastFragment = document.documentElement
  let lastOK = true
  let fragmentCount = 0

  let targetExplainer = container.querySelector('.fragment-explainer--target')
  let revealTarget = container.querySelector('.fragment-explainer--reveal')
  let requestExplainer = container.querySelector('.fragment-explainer--request')
  let rttExplainer = container.querySelector('.fragment-explainer--rtt')

  function revealLastFragment() {
    let outline = new FragmentOutline(lastFragment, { nature: lastOK ? 'success' : 'failure' })
    up.util.timer(800, () => outline.destroy({ animation: 'fade-out', duration: 700 }))
  }

  return [
    up.on('up:fragment:inserted', (event, fragment) => {
      fragmentCount++
      if (fragment.matches('[up-hungry]:not(#open-task-count)')) return
      if (fragment.matches('.tour-hint, .tour-hint-drawer')) return
      if (fragment.querySelector('.placeholder')) return
      if (fragment.className.includes('spinner')) return
      if (fragment.matches('up-modal, up-modal main, up-drawer, up-drawer main, up-popup, up-popup main')) fragment = up.layer.current.getBoxElement()
      lastFragment = fragment
      lastOK = event.ok
      targetExplainer.innerText = up.fragment.toTarget(fragment, { verify: false })
      if (mods.showFragments.checked && fragmentCount > 1) revealLastFragment()
    }),

    up.on(revealTarget, 'click', (event) => {
      up.event.halt(event)
      revealLastFragment()
    }),

    up.on('up:link:follow up:form:submit', ({ renderOptions }) => {
      let method = up.util.normalizeMethod(renderOptions.method)
      requestExplainer.innerText = `${method} ${renderOptions.url}`
    }),

    up.on('up:fragment:loaded', ({ request, response, revalidating }) => {
      if (revalidating) return

      let rtt = Math.max(response.loadedAt - request.builtAt, 0)
      let info = `${rtt} ms`
      if (request.fromCache) {
        info += ' <span class="text-muted">(cache)</span>'
      }
      rttExplainer.innerHTML = info
    })
  ]
})
