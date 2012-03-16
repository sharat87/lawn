# Mailing list pages (by MailChimp, I think).
if location.host.match /^us\d\.campaign-archive\d\.com$/
  # Hide the annoying bar at the top.
  $('#awesomebar')
    .css(top: '-50px')
    .hover (-> @style.top = 0), (-> @style.top = '-50px')

  # Add hint to the comments links for easier reach from pentadactyl.
  # For HN newsletter pages.
  $('li a').filter(-> @text is 'comments').each ->
    @setAttributeNS 'http://vimperator.org/namespaces/liberator',
      'hint', @parentNode.previousElementSibling.text + ' - comments'
