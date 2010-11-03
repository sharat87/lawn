nnoremap gd ?\(function\\|var\) \<<C-r><C-w>\><CR>

" Make program for use with closure js compiler
" set makeprg=/home/sharat/bin/closure\ --js=\"%\"\ --summary_detail_level=3\ --js_output_file=/dev/null
set makeprg=closure\ --js=\"%\"\ --summary_detail_level=3\ --js_output_file=/dev/null
set errorformat=%A%f:%l:\ %m,%-Z%p^

se ts=4
