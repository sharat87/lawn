$ ->

  if location.pathname.match /\/\+packages$/
    ($ 'td')
      .filter(-> @innerText == 'Precise')
      .css('font-weight': 'bold')
      .closest('tr')
      .css('background-color': '#FFFFB2')
