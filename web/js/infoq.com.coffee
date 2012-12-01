$ ->
  distractions = $('#header, #rightbar, div.sponsoredTextLinks, #footer, ' +
    'div.vendor-content-box, #relatedContent, div.comments-header, ' +
    'div.comments-sort, ol.comments, #summaryComponent, #problemsVideo')
      .add($('#presentationContent').prevAll())

  container = $ '#columns_container'
  playerComponent = $ '#playerComponent'
  playerContainer = $ '#playerContainer'
  player = null

  applyFocus = ->
    distractions.hide()
    container.css
      padding: 0
      margin: 0
    playerComponent.css width: 'auto'
    playerContainer.css
      width: '50%'

    unless player
      player = $ '#playerContainer > object'

    player.attr
      width: '100%'

  unapplyFocus = ->
    distractions.show()
    container.css
      padding: ''
      margin: ''
    playerComponent.css width: ''
    playerContainer.css
      width: ''
    player.attr
      width: ''
      height: ''

  toggleBtn = $('<li><label><input type=checkbox> Focus</label></li>')
    .prependTo('ul.view-type')
    .css
      'line-height': '30px'
      'margin-right': '12px'

  toggleBtn.change (e) ->
    if e.target.checked
      do applyFocus
    else
      do unapplyFocus
