" Author: Shrikant Sharat Kandula <shrikantsharat.k@gmail.com>
" Modeline: vim: set et sts=4 ts=8 sw=4 fdm=marker :

" File type detection {{{
aug user-ftdetect | au!
    au BufRead,BufNewFile *.plt,*.gnuplot setf gnuplot
    au BufRead,BufNewFile *.t setf cram
    au BufRead,BufNewFile build.gradle setf groovy
aug END
" }}}

" {{{ Comment Strings
aug user-cstrings | au!
    au FileType r setl cms=#\ %s
aug END
" }}}

" File type specific preferences {{{
aug user-ftprefs | au!

    " Highlight cursor line in quickfix window.
    au FileType qf setl nocursorline tw=0

    " Set spell when composing mails.
    au FileType mail setl spell

    " Don't scan `current and included files` for python.
    au FileType python setl cpt-=i

    " Two space indenting for certain languages.
    au FileType ruby,coffee,haskell setl sts=2 ts=2 sw=2

    " Need to explicitly turn on auto indentation for haskell files.
    au FileType haskell setl ai

    " Auto indentation for yaml files.
    au FileType yaml setl ai

    " Auto indentation for groovy (and so gradle) files.
    au FileType groovy setl ai

    " I don't want `/` as word-char in clojure.
    au FileType clojure setl isk-=/

    " Function names in shell scripts are okay with these characters.
    au FileType sh setl isk+=-,!,?

    " Deactivate highlighting hidden characters in conque terminals.
    au FileType conque_term setl nolist

    " These files are not editable anyway, lets have `q` mapped to closing them.
    au FileType help,man,qf nnoremap <buffer> <silent> q :q<CR>

aug END
" }}}
