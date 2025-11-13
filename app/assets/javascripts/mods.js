up.compiler('form#mods', function(form) {
  persistMods(form)

  return [
    up.on('up:link:follow up:form:submit', function(event) {
      if (form.fullPageLoads.checked) {
        event.preventDefault()
        let { url, method, params } = event.renderOptions
        up.network.loadPage({ url, method, params })
      }

      if (form.disableCache.checked) {
        event.renderOptions.cache = false
      }

      if (form.noPreviews.checked) {
        Object.assign(event.renderOptions, up.RenderOptions.NO_PREVIEWS)
      }

      if (form.noOverlays.checked && !event.target.matches('.tour-dot')) {
        event.renderOptions.layer = 'origin current'
      }

      if (form.noMotion.checked) {
        Object.assign(event.renderOptions, up.RenderOptions.NO_MOTION)
      }
    }),

    up.on('up:link:preload', (event) => {
      if (form.fullPageLoads.checked || form.disableCache.checked) {
        event.preventDefault()
      }
    }),

    up.on('up:form:validate', (event) => {
      if (form.noValidation.checked) {
        event.preventDefault()
      }
    }),

    up.on('up:request:load', ({ request }) => {
      if (form.extraLatency.checked) {
        request.headers['X-Extra-Latency'] = 'true'
      }
    }),

    up.on('up:click', { capture: true }, (event) => {
      if (form.showClicks.checked) {
        let style = {
          top: event.clientY + "px",
          left: event.clientX + "px"
        }
        let bubble = up.element.affix(document.body, '.click-bubble', { style })
        bubble.addEventListener('animationend', () => bubble.remove());
      }
    })
  ]
})

function persistMods(form) {
  if (loadFromLocation(form)) {
    saveToSession(form)
  } else {
    loadFromSession(form)
  }

  up.watch(form, () => saveToSession(form))
}

function loadFromLocation(form) {
  let hash = location.hash
  if (hash.startsWith('#')) { hash = hash.slice(1) }

  let madeChange = loadFromQueryString(form, hash)
  if (madeChange) {
    location.hash = ''
  }

  return madeChange
}

function loadFromQueryString(form, queryString) {
  let madeChange = false

  if (queryString) {
    let params = new URLSearchParams(queryString)
    for (let checkbox of form.querySelectorAll('input[type="checkbox"]')) {
      if (params.get(checkbox.name)) {
        checkbox.checked = true
        madeChange = true
        params.delete(checkbox.name)
      }
    }
  }

  return madeChange
}

function loadFromSession(form) {
  let storedQueryString = sessionStorage.getItem('mods/v1')
  return loadFromQueryString(form, storedQueryString)
}

function saveToSession(form) {
  let formData = new FormData(form)
  let queryString = new URLSearchParams(formData).toString()
  sessionStorage.setItem('mods/v1', queryString)
}
