//= require unpoly
//= require unpoly-bootstrap4

up.log.enable()

up.on('up:link:follow', '.tour-dot', (event, element) => { element.classList.add('viewed') })
