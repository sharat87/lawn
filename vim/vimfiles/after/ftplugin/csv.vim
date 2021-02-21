aug ssk_csv
	au! InsertLeave,TextChanged,CursorMoved,BufHidden <buffer>
	au InsertLeave,TextChanged <buffer> TabsLineUp
	au CursorMoved <buffer> HighlightCurrentColumn
	au BufHidden <buffer> call <SID>RemoveColHighlight()
aug END

" Undo work of easyalign on current delimiter.
" TODO: This :s command highlights matches and changes search patter. Fix.
command! -buffer CompactDelimiter exe '%s/' .. b:delimiter .. '\zs \+//ge'

nnoremap <LocalLeader>d :call <SID>SwitchDelimiter()<CR>
fun! s:SwitchDelimiter() abort
	" csv.vim plugin sets b:delimiter, so this depends on csv.vim plugin.
	let c = getchar()
	while c == "\<CursorHold>" | let c = getchar() | endwhile
	let c = nr2char(c)
	exe '%s/' .. b:delimiter .. ' */' .. c .. '/g'
	CSVInit
endfun

let s:match_id = -1
command! -buffer HighlightCurrentColumn call <SID>HighlightCurrentColumn()
fun! s:HighlightCurrentColumn() abort
	let line = getline('.')
	let c = count(getline('.')[:col('.') - 1], b:delimiter)
	call <SID>RemoveColHighlight()
	" TODO: If cursor is on a separator, highlight that separator in all lines.
	let s:match_id = matchadd('CSVHiGroup', '^\([^' . b:delimiter . ']*' . b:delimiter . '\)\{' . c . '\}\zs[^' . b:delimiter . ']\+')
endfun
fun! s:RemoveColHighlight() abort
	silent! call matchdelete(s:match_id)
endfun

command! -nargs=1 DataFrameOp py3 data_frame_op(<q-args>)
py3 <<EOPYTHON
def data_frame_op(code):
	import pandas as pd, io, vim
	sep = vim.current.buffer.vars['delimiter'].decode()
	df = pd.read_csv(io.StringIO('\n'.join(vim.current.buffer)), sep=sep)
	locs = {'df': df, 'sep': sep}
	exec(code, globals(), locs)
	vim.current.buffer[:] = locs['df'].to_csv(sep=locs['sep'], index=False).splitlines()
EOPYTHON
