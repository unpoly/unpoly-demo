//= require unpoly
//= require unpoly-bootstrap5

// Accelerate all links so the demo feels snappy.
// We still assign out [up-follow] manually so there's less magic for demo viewers.
up.link.config.instantSelectors.unshift('a[href]')
up.link.config.preloadSelectors.unshift('a[href]')

up.form.config.groupSelectors.unshift('.form-group')

up.network.config.lateTime = 1250

// Enable more logging for curious users.
up.log.enable()

// Gray out tour dots once clicked.
up.on('up:link:follow', '.tour-dot', (event, element) => { element.classList.add('viewed') })

up.compiler('.fragment-explainer', function(container) {
  let lastFragment = document.documentElement

  let targetExplainer = container.querySelector('.fragment-explainer--target')
  let revealTarget = container.querySelector('.fragment-explainer--reveal')
  let requestExplainer = container.querySelector('.fragment-explainer--request')
  let rttExplainer = container.querySelector('.fragment-explainer--rtt')

  return [
    up.on('up:fragment:inserted', (_event, fragment) => {
      if (fragment.matches('[up-hungry]')) return
      if (fragment.querySelector('.placeholder')) return
      if (fragment.matches('up-modal, up-modal main, up-drawer, up-drawer main, up-popup, up-popup main')) fragment = up.layer.current.getBoxElement()
      lastFragment = fragment
      targetExplainer.innerText = up.fragment.toTarget(fragment, { verify: false })
      if (config.showFragments.checked) showInsertedFlash(lastFragment)
    }),

    up.on(revealTarget, 'click', (event) => {
      up.event.halt(event)
      showInsertedFlash(lastFragment)
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

up.compiler('form#config', function(form) {
  return [
    up.on('up:link:follow up:form:submit', function(event) {
      if (form.disableCache.checked) {
        event.renderOptions.cache = false
      }
    }),

    up.on('up:link:preload', (event) => {
      if (form.disableCache.checked) {
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

function showInsertedFlash(fragment) {
  fragment = up.fragment.get(fragment)
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

function findButton(origin) {
  if (origin.matches('.btn')) {
    return origin
  } else {
    let form = origin.closest('form')
    return up.form.submitButtons(form)[0]
  }
}

// Show a spinning wheel inside the button.
up.preview('btn-spinner', function(preview) {
  let button = findButton(preview.origin)
  // Keep the button dimensions while we're hiding its content.
  preview.setStyle(button, { height: button.offsetHeight + 'px', width: button.offsetWidth + 'px' })
  preview.swapContent(button, '<span class="btn-spinner"></span>')
})

up.preview('popup-spinner', function(preview) {
  preview.showPlaceholder('<div class="popup-spinner"></div>')
})

up.preview('main-spinner', function(preview) {
  let main = up.fragment.closest(preview.fragment, ':main')
  preview.insert(main, 'afterbegin', '<div class="main-spinner"></div>')
})

// Setting a `-done` class will line-through the task text.
up.preview('finish-task', function(preview) {
  preview.addClass('-done')
})

// Removing a `-done` class will remove the line-through decoration from the task text.
up.preview('unfinish-task', function(preview) {
  preview.removeClass('-done')
})

up.preview('add-task', function(preview) {
  let form = preview.origin.closest('form')
  let text = preview.params.get('task[text]')

  if (text) {
    preview.insert(form, 'afterend', `
      <div class="task task-item">
        <span class="task-item--toggle"></span>
        <span class="task-item--text">${up.util.escapeHTML(text)}</span>
      </div>
    `)

    form.reset()
  }
})

up.preview('clear-tasks', function(preview) {
  let doneTasks = up.fragment.all('.task.-done', { layer: preview.layer })
  for (let doneTask of doneTasks) {
    preview.hide(doneTask)
  }
})

up.compiler('#tasks', function(container) {
  let draggingItem

  up.on(container, 'dragstart', '.task-item', function(event, item) {
    draggingItem = item
    item.classList.add('-dragging')
  })

  up.on(container, 'dragover', '.task', function(event, item) {
    event.preventDefault() // prime drop event
    item.classList.add('-dropping')
  })

  up.on(container, 'dragleave', '.task', function(event, item) {
    item.classList.remove('-dropping')
  })

  up.on(container, 'drop', '.task', function(event, dropItem) {
    if (!draggingItem) return
    event.preventDefault()

    let draggingID = draggingItem.dataset.id
    let referenceID = dropItem.dataset.id

    draggingItem.classList.remove('-dragging')
    dropItem.classList.remove('-dropping')

    if (draggingID !== referenceID) {
      up.render({
        target: '#tasks',
        method: 'patch',
        url: `/tasks/${draggingID}/move`,
        params: { reference: referenceID },
        fallback: true,
        preview: (preview) => preview.insert(dropItem, 'afterend', draggingItem)
      })
    }
  })

})
