if exists('g:loaded_eunuch')
	" The Remove command is an alias to Unlink, by default. I want it to behave like :Delete.
	command! -bar -bang Remove Delete<bang>
endif
