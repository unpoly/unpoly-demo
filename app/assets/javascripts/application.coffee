#= require unpoly
#= require unpoly-bootstrap4

#up.on 'up:fragment:loaded', (event) ->
#  if event.response.text.indexOf('Exception caught') >= 0
#    event.preventDefault()
#    event.request.loadPage()

#up.link.config.instant.push('a:not(.btn)')
#up.link.config.preload.push('a:not(.btn)')

up.log.enable()

