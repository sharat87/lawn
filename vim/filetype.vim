aug ftdetect-user
au!

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" File type detection logic

" Less Stylesheets
au BufRead,BufNewFile *.less setf less

" Clojure
au BufRead,BufNewFile *.clj,*.cljs setf clojure

" GNUPlot
au BufRead,BufNewFile *.plt,*.gnuplot setf gnuplot

" log4j log files
au BufRead,BufNewFile *.log setf log4j

" Pipe separated log files
au BufRead,BufNewFile *_{SQL,REQUEST,CLIENTREQUEST,WORKFLOW}_*.log setf elog

" Cram test files
au BufRead,BufNewFile *.t setf cram

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" File type specific preferences

au FileType qf setl cursorline

au FileType mail setl spell

au FileType make setl noet sts=0 ts=4 sw=4

au FileType python setl cpt-=i

au FileType ruby,coffee setl sts=2 ts=2 sw=2

au FileType yaml,haskell setl ai et sts=2 ts=2 sw=2

au FileType clojure setl isk-=/

au FileType sh setl isk+=-,!,?

au FileType conque_term setl nolist

" These files are not editable anyway, lets have `q` mapped to closing them.
au FileType help,man,qf nnoremap <buffer> <silent> q :q<CR>

aug END
