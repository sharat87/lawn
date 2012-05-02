choices = $ '#sr-header-area a.choice'

filterInput = $ '<input class=finder-input>'
popup = $('<div id=r-popup />').appendTo(document.body)
  .html(('<a href="' + c.href + '">' + c.text + '</a>' for c in choices).join(''))
  .prepend(filterInput)

links = popup.children 'a'

updateFilter = (filterStr=filterInput.val()) ->
  filterStr = filterStr.toLowerCase()
  links
    .removeClass('active')
    .hide()
    .filter(-> @text.toLowerCase().indexOf(filterStr) isnt -1)
    .show()
    .first()
    .addClass('active')

filterInput.keyup (e) ->

  if e.which is 27 # ESC key
    do popup.hide
    do filterInput.blur
    do links.show
    filterInput.val ''

  else if e.which is 38 or e.which is 40 # Up/Down arrows
    currentActive = links.filter('.active')

    if currentActive.length is 0
      links.first().addClass('active')
      return

    newActive = currentActive[if e.which is 38 then 'prevAll' else 'nextAll']('a:visible')
      .first()

    if newActive.length isnt 0
      newActive.addClass 'active'
      currentActive.removeClass 'active'

  else if e.which is 13 # Enter key
    do links.filter('.active').click
    # window.location = links.filter('.active').attr 'href'

  else
    do updateFilter

$(document).keyup (e) ->
  return if $(e.target).is(':input')
  if e.which is 82 # r key
    console.log(e.which)
    do popup.show
    do filterInput.focus

do popup.hide
