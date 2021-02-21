setlocal commentstring=--\ %s

command! -buffer CleanupSqlExtract call <SID>CleanupSqlExtract()
fun! s:CleanupSqlExtract()
	let l:pos = getcurpos()
	%s/\s\+$//e
	%s/insert into \zs\w\+\.//ie
	silent g/^SET DEFINE OFF;$\|^COMMIT;$/d
	call setpos('.', l:pos)
endfun

nnoremap <buffer> <LocalLeader>d :<C-u>call <SID>RunChemist('dev1')<CR>
nnoremap <buffer> <LocalLeader>q :<C-u>call <SID>RunChemist('qa1')<CR>

fun! s:RunChemist(env) abort
	py3 chemist.run_query_under_cursor(lambda _, q: vim.eval('a:env') + '_' + _get_app_from_query(q))
endfun

py3 <<EOPYTHON
import chemist, vim, re
def _get_app_from_query(sql):
    pat = r'(\b from | ^update | ^insert \s+ into | ^delete \s+ (from)? ) \s+ cip_'
    return ('cip' if re.search(pat, sql, re.IGNORECASE | re.VERBOSE) else 't3')
EOPYTHON
