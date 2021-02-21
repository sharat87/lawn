let $NOTES_HOME = $HOME . '/Dropbox/notes'

nnoremap <C-e> :Files $NOTES_HOME<CR>
" nnoremap <C-e> :CtrlP $NOTES_HOME<CR>

nnoremap <Leader><C-e> :e $NOTES_HOME/.md<Left><Left><Left>

" Live search my notes.
nnoremap <silent> <C-s> :call live_search#start($NOTES_HOME)<CR>

aug ssk_notes
	au!
	autocmd BufReadPost $NOTES_HOME/**/*.md setl tags=$NOTES_HOME/tags textwidth=120
	autocmd BufWritePost $NOTES_HOME/**/*.md call <SID>NotesUpdateTags('<afile>')
	autocmd BufReadPost $NOTES_HOME/**/*.md call <SID>LocalHighlights()
aug END

" Vim version of updating tags is much slower than doing it in Python.
command -bar NotesUpdateTagsVim call <SID>NotesUpdateTagsVim('')
fun s:NotesUpdateTagsVim(saved_file) abort
	let tags_file = $NOTES_HOME . '/tags'
	let tags_lines = []
	for path in glob($NOTES_HOME . '/**/*.md', 1, 1)
		let n = 1
		for line in readfile(path)
			if line =~ '^#\+'
				call add(tags_lines, line . "\t" . path . "\t" . n)
			endif
			let n += 1
		endfor
	endfor
	call writefile(tags_lines, tags_file)
endfun

command -bar NotesUpdateTagscall <SID>NotesUpdateTags('')
fun s:NotesUpdateTags(saved_file) abort
	py3 import vim, tags_gen
	py3 tags_gen.generate(vim.eval('$NOTES_HOME'), ['*.md'], vim.eval('$NOTES_HOME') + '/tags')
endfun

command -bar LocalHighlights call <SID>LocalHighlights()
fun s:LocalHighlights() abort
	let load_matches = 0
	call clearmatches()
	for line in getline(1, '$')
		if line ==# '</vim_matches>'
			let load_matches = 0
		endif

		if load_matches
			" TODO: Use hlexists to check if the group is present before creating match.
			let [grp; pat] = split(line, ' ', 1)
			call matchadd(grp, join(pat, ' '))
		endif

		if line ==# '<vim_matches>'
			let load_matches = 1
		endif
	endfor
endfun
