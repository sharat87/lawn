augroup ftdetect-user
autocmd!

" Objective J
autocmd BufRead,BufNewFile *.j setfiletype objj

" Less Stylesheets
autocmd BufRead,BufNewFile *.less setfiletype less

" Markdown
autocmd BufRead,BufNewFile *.mkd setfiletype mkd

" Flex/Flash related
autocmd BufRead,BufNewFile *.mxml setfiletype mxml
autocmd BufRead,BufNewFile *.as setfiletype actionscript

" Clojure
autocmd BufRead,BufNewFile *.clj setfiletype clojure

" File type preferences
autocmd Syntax make setlocal noet sts=0 ts=4 sw=4

augroup END
