// Unpoly //////////////////////////////////////////////////////////////////////////////////////////////////////////////

//= require unpoly
//= require unpoly-bootstrap5

// Accelerate all links so the demo feels snappy.
// We still assign out [up-follow] manually so there's less magic for demo viewers.
up.link.config.instantSelectors.unshift('a[href]')
up.link.config.preloadSelectors.unshift('a[href]')

// We use a .form-group to contain each (label, input, error, help) tuple.
// Unpoly can use this to only update the affected a group when validating.
up.form.config.groupSelectors.unshift('.form-group')

// Since we're rendering instant loading state for all interactions in the demo,
// wait longer until we show the progress bar.
up.network.config.lateTime = 1250

up.radio.config.hungrySelectors.push('#tour-hint')

up.fragment.config.runScripts = true

// Enable more logging for curious users.
up.log.enable()


// Tour /////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// Gray out tour dots once clicked.
up.on('up:link:follow', '.tour-dot', (event, element) => { element.classList.add('viewed') })

up.compiler('#tour-hint', function(hint, data) {
  let outlines = []

  function destroyOutlines() {
    for (let outline of outlines) {
      outline.destroy()
    }
    hint.innerHTML = ''
  }

  for (let selector in data.outline) {
    let nature = data.outline[selector]
    let fragment = up.fragment.get(selector)
    let outline = new FragmentOutline(fragment, { nature })
    outlines.push(outline)
    up.fragment.onAborted(fragment, () => destroyOutlines())
  }

  up.fragment.onAborted(hint, () => destroyOutlines())

})

// Fragment explainer //////////////////////////////////////////////////////////////////////////////////////////////////

up.compiler('.fragment-explainer', function(container) {
  let lastFragment = document.documentElement
  let lastOK = true

  let targetExplainer = container.querySelector('.fragment-explainer--target')
  let revealTarget = container.querySelector('.fragment-explainer--reveal')
  let requestExplainer = container.querySelector('.fragment-explainer--request')
  let rttExplainer = container.querySelector('.fragment-explainer--rtt')

  function revealLastFragment() {
    let outline = new FragmentOutline(lastFragment, { nature: lastOK ? 'success' : 'failure' })
    up.util.timer(500, () => outline.destroy({ animation: 'fade-out', duration: 750 }))
  }

  return [
    up.on('up:fragment:inserted', (event, fragment) => {
      if (fragment.matches('[up-hungry]')) return
      if (fragment.matches('.tour-hint, #tour-hint')) return
      if (fragment.querySelector('.placeholder')) return
      if (fragment.className.includes('spinner')) return
      if (fragment.matches('up-modal, up-modal main, up-drawer, up-drawer main, up-popup, up-popup main')) fragment = up.layer.current.getBoxElement()
      lastFragment = fragment
      lastOK = event.ok
      targetExplainer.innerText = up.fragment.toTarget(fragment, { verify: false })
      if (config.showFragments.checked) revealLastFragment()
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

up.compiler('form#config', function(form) {
  return [
    up.on('up:link:follow up:form:submit', function(event) {
      if (form.disableCache.checked) {
        event.renderOptions.cache = false
      }
      if (form.noPreviews.checked) {
        Object.assign(event.renderOptions, up.RenderOptions.NO_PREVIEWS)
      }
      if (form.noMotion.checked) {
        Object.assign(event.renderOptions, up.RenderOptions.NO_MOTION)
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

// function showInsertedFlash(fragment) {
//   fragment = up.fragment.get(fragment)
//   fragment.classList.add('new-fragment', 'inserted')
//   up.util.timer(0, () => fragment.classList.remove('inserted'))
//   up.util.timer(750, () => fragment.classList.remove('new-fragment'))
// }

class FragmentOutline {
  constructor(fragment, { nature, label } = {}) {
    this._fragment = fragment
    this._nature = nature || 'success'
    this._label = label ?? this._autoLabel()
    this._cleaner = up.util.cleaner()
    this._render()
  }

  _autoLabel() {
    if (this._nature === 'success' || this._nature === 'failure') {
      return up.fragment.toTarget(this._fragment, { verify: false })
    }
  }

  _render() {
    let layer = up.layer.get(this._fragment)
    this._outlineElement = layer.affix(`.fragment-outline.-${this._nature}`)
    if (this._label) {
      this._labelElement = up.element.affix(this._outlineElement, '.fragment-outline--label', {text: this._label})
    }
    this._updatePosition()
    this._cleaner(
      up.on(document, 'scroll', () => this._updatePosition()),
      up.on(window, 'resize', () => this._updatePosition()),
    )
  }

  _updatePosition() {
    let rect = this._fragment.getBoundingClientRect()
    Object.assign(this._outlineElement.style, {
      top: rect.top + 'px',
      left: rect.left + 'px',
      width: rect.width + 'px',
      height: rect.height + 'px'
    })
  }

  destroy({ animation = 'fade-out', duration = 500 } = {}) {
    up.destroy(this._outlineElement, { animation, duration })
    this._cleaner.clean()
  }
}

// function showFragmentOutline(fragment, options) {
//   let outline = new FragmentOutline(fragment, options)
//   let offDismissed
//   let destroy = (...args) => {
//     offDismissed()
//     outline.destroy(...args)
//   }
//   offDismissed = up.on('up:layer:dismissed', ({ layer }) => {
//     if (layer.element.matches('.tour-hint')) {
//       destroy({ animation: 'fade-out', duration: 300 })
//     }
//   })
//   return destroy
// }


// Notifications ///////////////////////////////////////////////////////////////////////////////////////////////////////

// Prompt user to reload when frontend assets changeds on the server.
up.on('up:assets:changed', function() {
  up.element.show(document.querySelector('#new-version'))
})

// Remove notification flashes after a few seconds.
up.compiler('.alert', function(alert) {
  up.util.timer(4000, () => up.destroy(alert, { animation: 'move-to-top' }))
})


// Loading state ///////////////////////////////////////////////////////////////////////////////////////////////////////

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

// Show a spinning wheel inside a loading popup overlay
up.preview('popup-spinner', function(preview) {
  preview.showPlaceholder('<div class="popup-spinner"></div>')
})

// Show a spinning wheel inside a loading main element
up.preview('main-spinner', function(preview) {
  let main = up.fragment.closest(preview.fragment, ':main')
  preview.insert(main, 'afterbegin', '<div class="main-spinner"></div>')
})

// Shorten placeholder table to the maximum number of rows given
up.compiler('.placeholder-wave', function(placeholder, { rows = 15 }) {
  let trs = placeholder.querySelectorAll('tr')
  for (let i = 0; i < trs.length - rows; i++) {
    trs[i].remove()
  }
})


// Templates with simple {{variable}} substitution /////////////////////////////////////////////////////////////////////

up.on('up:template:clone', '[type="text/minimustache"]', function(event) {
  let template = event.target.innerHTML
  let filled = template.replace(/{{(\w+)}}/g, (_match, variable) => up.util.escapeHTML(event.data[variable]))
  event.nodes = up.element.createNodesFromHTML(filled)
})


// Tasks ///////////////////////////////////////////////////////////////////////////////////////////////////////////////

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
  let newItem = up.template.clone('#task-preview', { text })
  preview.insert(form, 'afterend', newItem)
  form.reset()
})

up.preview('clear-tasks', function(preview) {
  let doneTasks = up.fragment.all('.task.-done')
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

    draggingItem.classList.remove('-dragging')
    dropItem.classList.remove('-dropping')

    if (draggingItem !== dropItem) {
      up.render({
        target: '#tasks',
        method: 'patch',
        url: `/tasks/${draggingItem.dataset.id}/move`,
        params: { reference: dropItem.dataset.id },
        fallback: true,
        preview: (preview) => preview.insert(dropItem, 'afterend', draggingItem)
      })
    }
  })

})
