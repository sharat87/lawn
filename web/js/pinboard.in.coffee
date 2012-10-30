# Display domain name of links next to the bookmarks
$ ->
  $('a.bookmark_title').after ->
    href = $(@).attr 'href'
    ' <a href="' + href.match(/.*:\/\/.+?\//) + '" style="margin-left:7px;color:gray">' +
      href.match(/:\/\/(.+?)\//)[1] + '</a>'
