setlocal spell expandtab

" Shortcut phrases and typos.
ia <buffer> isntead instead
ia <buffer> stmt statement
ia <buffer> iwll will
ia <buffer> respose response

" My python module for markdown utilities.
py3 import markdown_utils
py3 import importlib; importlib.reload(markdown_utils)

" Custom matches. TODO: Move these to after/syntax/markdown.vim file.
call matchadd('Comment', '\*blank\*', 20)  " To use as a table cell contents, indicating blank.
call matchadd('Todo', '\c\<(note\|todo\|fixme\|xxx\|tbd)\>')

" " Auto-capitalization.
" augroup SENTENCES
"     au!
"     autocmd InsertCharPre * if search('\v(%^|[.!?]\_s+|\_^\-\s|\_^title\:\s|\n\n)%#', 'bcnw') != 0 | let v:char = toupper(v:char) | endif
" augroup end

" " Fancy quotes.
" inoremap <silent> <buffer> <expr> ' <SID>Quote('‘', "'", '’')
" inoremap <silent> <buffer> <expr> " <SID>Quote('“', '"', '”')
" fun s:Quote(open, mid, close) abort
"   if synIDattr(synID(line('.'), col('.') - 1, 1), 'name') ==# 'markdownCode'
"     return a:mid
"   else
"     let l:pchar = col('.') > 2 ? getline('.')[col('.')-2] : ' '
"     return l:pchar == ' ' ? a:open : a:close
"   endif
" endfun

" Start code fences automatically.
inoremap <expr> <silent> <buffer> `
			\ col('.') == 1 && line('.') > 1 && empty(getline(line('.') - 1)) ?
			\ "```\<CR>```\<Up>" : '`'

" Start code block automatically.
inoremap <expr> <silent> <buffer> :
			\ col('.') == 1 && line('.') > 1 && empty(getline(line('.') - 1)) ?
			\ ":::\<C-t>" : ':'

" Start yaml metadata block automatically.
inoremap <expr> <silent> <buffer> - line('.') == 1 && col('.') == 1 ? "---\<CR>---\<Up>\<CR>" : '-'

" Intelligent formatting routine.
" setlocal formatexpr=FormatMarkdown()
" setlocal formatexpr=py3eval('markdown_utils.format_any()')
setlocal formatoptions+=n

" setlocal formatlistpat=^\s*\(\d\+\.\|-\|\*\)\s+
" setlocal autoindent

" Format a markdown table.
nnoremap <silent> <buffer> <LocalLeader>t :py3 markdown_utils.format_table()<CR>

" Counts auto-updating.
augroup counter
	au!
	au BufWritePre <buffer> call <SID>AutoUpdateCounts()
augroup END
fun s:AutoUpdateCounts() abort
	let num = 1
	let counts = {}  " line-number: count-number
	let current_counters = {}  " header-level: line-number

	for line in getline(1, '$')
		if line =~# '\v^#+ '
			let level = strlen(split(line)[0])
			for l in keys(current_counters)
				if l >= level
					call remove(current_counters, l)
				endif
			endfor
			if line =~# '\v^#+ .+ \(count: \d+\)$'
				let counts[num] = 0
				let current_counters[level] = num
			endif

		elseif line =~# '\v^(\d+\.|-) '
			for n in values(current_counters)
				let counts[n] += 1
			endfor

		endif
		let num += 1
	endfor

	for [num, cnt] in items(counts)
		call setline(num, getline(num)->substitute('\v(count: )\d+(.)$', '\1' .. string(cnt) .. '\2', ''))
	endfor

endfun

" Pushing text to a `.done` file.
" nnoremap <buffer> <silent> <Leader>vv :DoForCurrentLine
nnoremap <buffer> <silent> <Leader>v :set opfunc=PushAsDoneOpFunc<CR>g@
" vnoremap <buffer> <silent> <Leader>v :DoForSelection
function! PushAsDoneOpFunc(type) abort
	let marks = a:type ==? 'vis' ? '<>' : '[]'
	let [_, l1, c1, _] = getpos("'" . marks[0])
	let [_, l2, c2, _] = getpos("'" . marks[1])

	let text = []

	if l1 == l2
		let text = [getline(l1)]
		call setline(l1, text[:c1 - 1] . text[c2 + 1:])
		call cursor(l2, c1)

	else
		let text = getline(l1, l2)
		call execute(l1 . ',' . l2 . 'delete _')
		call cursor(l1, c1)

	endif

	while text[0] ==# ''
		let text = text[1:]
	endwhile

	while text[-1] ==# ''
		let text = text[:-2]
	endwhile

	call insert(text, strftime('%Y-%m-%d %H:%M:%S %Z'))
	call insert(text, '')

	let done_file = expand('%:p:r') . '.done.' . expand('%:e')
	call writefile(text, done_file, 'a')
endfunction
