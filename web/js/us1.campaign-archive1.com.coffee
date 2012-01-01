# Hide the annoying bar at the top
do $('#awesomebar').hide

# Add hint to the comments links for easier reach from pentadactyl
$('li a').filter(-> @text is 'comments').each ->
  @setAttributeNS 'http://vimperator.org/namespaces/liberator',
    'hint', @parentNode.previousElementSibling.text + ' - comments'
