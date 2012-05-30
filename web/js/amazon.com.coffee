###
$.post '--', {category: }
###

applyAwesomeness = ->
  # do $('img.orderActions').first().click

do ->
  intervalId = setInterval(
    (->
      return unless document.getElementById('actionSelect1')?
      setTimeout applyAwesomeness, 500
      clearInterval intervalId),
    100)
