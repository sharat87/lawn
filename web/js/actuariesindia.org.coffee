$ ->
  do $('table:last').remove

  # Unmarquee!
  $('#marqueecontainer').css(height: 'auto')
  $('#vmarquee').removeAttr 'id'
