nnoremap <silent> <buffer> <LocalLeader>d :py3 roast.run(use={'url_prefix': 'http://dev.cip.spindices.com/cipservice/api'})<CR>
nnoremap <silent> <buffer> <LocalLeader>q :py3 roast.run(use={'url_prefix': 'http://qa1.cip.spdji.com/cipservice/api'})<CR>

nnoremap <silent> <buffer> <LocalLeader>h :py3 roast.run(use={'url_prefix': 'http://httpbin.org/'})<CR>
