//= require unpoly
//= require unpoly-bootstrap5
//= require dist/js/tom-select.complete
//= require_tree .

// Unpoly //////////////////////////////////////////////////////////////////////////////////////////////////////////////

// Accelerate all links so the demo feels snappy.
// We still assign out [up-follow] manually so there's less magic for demo viewers.
up.link.config.instantSelectors.unshift('a[href]:is([up-follow], [up-target])')
up.link.config.preloadSelectors.unshift('a[href]:is([up-follow], [up-target])')

// We use a .form-group to contain each (label, input, error, help) tuple.
// Unpoly can use this to only update the affected a group when validating.
up.form.config.groupSelectors.unshift('.form-group')

up.fragment.config.autoHistoryTargets.unshift('.panes--content')

// Since we're rendering instant loading state for all interactions in the demo,
// wait longer until we show the progress bar.
up.network.config.lateTime = 1250

// up.radio.config.hungrySelectors.push('.tour-hint')

up.fragment.config.runScripts = true

// Enable more logging for curious users.
up.log.enable()


// Tour /////////////////////////////////////////////////////////////////////////////////////////////////////////////////


function tourDrawerAutoPosition(tourDot) {
  const rect = tourDot.getBoundingClientRect()
  const viewportWidth = window.innerWidth

  // Compute the element's horizontal center position in the viewport
  const elementCenter = rect.left + rect.width / 2

  // Compare with viewport midpoint
  if (elementCenter < viewportWidth / 2) {
    return 'right'
  } else {
    return 'left'
  }
}

// Gray out tour dots once clicked.
up.on('up:link:follow', '.tour-dot', (event, dot) => {
  dot.classList.add('viewed')

  event.renderOptions.position ??= tourDrawerAutoPosition(dot)
})

up.compiler('.tour-hint', function(hint, data) {
  let outlines = []

  function destroyOutlines() {
    for (let outline of outlines) {
      outline.destroy()
    }
    hint.innerHTML = ''
  }

  for (let selector in data.outline) {
    let nature = data.outline[selector]
    let fragment = up.fragment.get(selector, { layer: 'parent' })
    if (!fragment) {
      console.warn("[.tour-hint] Could not find fragment for selector", selector)
      continue
    }

    let label
    if (nature === 'success' || nature == 'failure') {
      label = selector
    } else {
      label = false
    }

    let outline = new FragmentOutline(fragment, { nature, label })
    outlines.push(outline)
    up.fragment.onAborted(fragment, () => destroyOutlines())
  }

  up.fragment.onAborted(hint, () => destroyOutlines())

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
    let { top, right, bottom, left } = this._fragment.getBoundingClientRect()

    // Make sure the outline doesn't draw outside screen bounds
    let outline = up.element.styleNumber(this._outlineElement, 'outline-width')
    top = Math.max(top, outline)
    left = Math.max(left, outline)
    right = Math.min(right, document.documentElement.clientWidth - outline)
    bottom = Math.min(bottom, document.documentElement.clientHeight - outline)

    Object.assign(this._outlineElement.style, {
      top: top + 'px',
      left: left + 'px',
      width: (right - left) + 'px',
      height: (bottom - top) + 'px'
    })
  }

  destroy({ animation = 'fade-out', duration = 500 } = {}) {
    up.destroy(this._outlineElement, { animation, duration })
    this._cleaner.clean()
  }
}


// Notifications ///////////////////////////////////////////////////////////////////////////////////////////////////////

// // Prompt user to reload when frontend assets changeds on the server.
// up.on('up:assets:changed', function() {
//   up.element.show(document.querySelector('#new-version'))
// })




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
  let text = preview.params.get('task[text]')
  let newItem = up.template.clone('#task-preview', { text })
  let form = preview.origin.closest('form')
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
