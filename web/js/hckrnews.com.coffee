# Add a nice pentadactyl hint to the comment links
($ 'a.hn').each ->
  hint = ($ this).next().text().substr(0, 16) + '…'
  @setAttributeNS 'http://vimperator.org/namespaces/liberator', 'hint', hint
