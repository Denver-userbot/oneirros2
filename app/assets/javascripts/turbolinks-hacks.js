document.addEventListener('turbolinks:click', function (event) {
  var anchorElement = event.target
  var isSamePageAnchor = (
    anchorElement.hash &&
    anchorElement.origin === window.location.origin &&
    anchorElement.pathname === window.location.pathname
  )
  
  if (isSamePageAnchor) {
    Turbolinks.controller.pushHistoryWithLocationAndRestorationIdentifier(
      event.data.url,
      Turbolinks.uuid()
    )
    event.preventDefault()
  }
})


