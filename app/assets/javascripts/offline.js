const CLASS_OFFLINE = 'offline-link'
const SELECTOR_LINK = 'a, [up-href]'
const TEST_REQUEST_TIMEOUT = 10_000
const POLL_PAUSE_ONLINE = 10_000
const POLL_PAUSE_OFFLINE = 3_000

let isOffline = false

function suspectOffline(newOffline) {
  if (isOffline === newOffline) return
  isOffline = newOffline
  let log = 'App is ' + (isOffline ? 'offline' : 'online')
  up.emit('app:connectivity:changed', { isOffline, log })
  if (isOffline) {
    showFlash('danger', 'You are offline')
    markLinks()
  } else {
    showFlash('success', 'You are online')
    unmarkLinks()
  }
}

function scheduleTestRequest() {
  let delay = isOffline ? POLL_PAUSE_OFFLINE : POLL_PAUSE_ONLINE
  setTimeout(makeTestRequest, delay)
}

async function makeTestRequest() {
  let testPath = getFaviconPath()
  const abortController = new AbortController()
  const timeoutTimer = setTimeout(() => controller.abort(), TEST_REQUEST_TIMEOUT)
  try {
    // Not using up.request() to keep the log silent
    await fetch(testPath, { method: 'HEAD', cache: 'no-store', signal: abortController.signal })
    suspectOffline(false)
  } catch (error) {
    suspectOffline(true)
  } finally {
    clearTimeout(timeoutTimer)
    scheduleTestRequest()
  }
}

function getFaviconPath() {
  let link = document.querySelector('link[rel~="icon"]')
  return link?.href || '/favicon.ico'
}

function isFollowableOffline(link) {
  if (!up.link.isFollowable(link)) {
    return false
  }

  let followOptions = up.link.followOptions(link)
  let requestAttrs = up.util.pick(followOptions, ['method', 'url', 'params', 'headers'])

  // We have links with inlined HTML, e.g. a[up-fragment]
  if (!requestAttrs.url) {
    return true
  }

  let cachedRequest = up.cache.get(requestAttrs)
  return cachedRequest?.state === 'loaded'
}

function getAllLinks() {
  return document.querySelectorAll(SELECTOR_LINK)
}

function markLinks(links = getAllLinks()) {
  for (let link of links) {
    if (!isFollowableOffline(link)) {
      link.classList.add(CLASS_OFFLINE)
    }
  }
}

function unmarkLinks() {
  for (let link of document.querySelectorAll('.' + CLASS_OFFLINE)) {
    link.classList.remove(CLASS_OFFLINE)
  }
}

up.compiler(SELECTOR_LINK, { batch: true }, function(links) {
  if (isOffline) {
    markLinks(links)
  }
})

// Runs when preloading
up.on('up:request:offline', function({ request }) {
  suspectOffline(true)
})

// Don't use up:fragment:loaded, as that also fires when a page is loaded from cache.
up.on('up:request:loaded', function() {
  suspectOffline(false)
})

scheduleTestRequest()

up.on('up:fragment:offline', async function({ renderOptions, request, retry }) {
  if (renderOptions.origin && request.method !== 'GET') {
    let layer = await up.layer.open({ content: '#offline-modal', size: 'small' })
    layer.on('up:click', '#retry-btn', () => retry({ confirm: false }))
  }
})
