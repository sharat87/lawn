command! -buffer -bar Pretty call <SID>Pretty()

fun! s:Pretty() abort
	py3 <<EOPYTHON
import json, vim
vim.current.buffer[:] = json.dumps(
	json.loads('\n'.join(vim.current.buffer), encoding='utf-8'),
	indent=(' ' * vim.current.buffer.options['shiftwidth'])
			if vim.current.buffer.options['expandtab'] else '\t',
).splitlines()
EOPYTHON
endfun
