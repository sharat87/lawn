fun! s:DoSub(name, rev) abort
    let l:lines = readfile(globpath(&rtp, 'replacements/' . a:name . '.json', 1, 1)[0])

    " Clear lines starting with `//`, regarded as comments.
    " Don't remove those lines so as to keep line numbers in error messages meaningful.
    let l:lines = map(l:lines, {i, v -> v =~ '^\s*//' ? '' : v})

    let l:replacements = json_decode(join(l:lines, "\n"))
    for [key, val] in items(l:replacements)
        if a:rev
            let [key, val] = [val, key]
        endif
        exe '%s?\V\<' . key . '\>?' . val . '?Ige'
    endfor
endfun

fun! s:CompleteFn(lead, line, pos) abort
    let files = globpath(&rtp, 'replacements/*' . a:lead . '*.json', 1, 1)
    return map(files, 'substitute(fnamemodify(v:val, ":t"), "\.json$", "", "")')
endfun

command! -narg=+ -complete=customlist,<SID>CompleteFn Replacement call <SID>DoSub(<f-args>)
