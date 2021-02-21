compiler pylint

" Bigger text width for python please.
setlocal textwidth=120

" Don't scan `current and included files` for python.
setlocal complete-=i

" Don't buffer python output, if we're running the python file within vim.
let $PYTHONUNBUFFERED=1

" " Lint on save
" setlocal makeprg=pylint\ --output-format=parseable
" augroup PythonLinting
"   autocmd!
"   autocmd BufWritePost *.py silent Make <afile> | silent redraw!
" augroup END
