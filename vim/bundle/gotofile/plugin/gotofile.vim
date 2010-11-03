" vim600: set foldmethod=marker:
" $Id:$
" PURPOSE: {{{
"   - GotoFile: Switch to an auto-completing buffer to open a file quickly.
"
" REQUIREMENTS:
"   - Vim 7.0
"
" USAGE:
"   Put this file in your ~/.vim/plugin directory.
"   If you are working on a project, go to the root directory of the project,
"   then execute:
"
"       :GotoFileCache .<CR>
"       or
"       :GC .<CR>
"
"   This will recursively parse the directory and create the internal cache.
"
"   You can also put in multiple arguments in :GC:
"
"       :GC /dir1 /dir2 /dir3
"
"   You can add to the cache by calling :GC again.  File with the same path
"   will not be added to the cache twice.
"
"   To Goto a file:
"
"       :GotoFile<CR>
"       or
"       :GF<CR>
"
"   This opens a scratch buffer that you can type in the file name.  Press
"   <Esc> will quit the buffer, while <Enter> will select and edit the file.
"
"   To clear the internal cache, do:
"
"       :GotoFileCacheClear<CR>
"       or
"       :GCC<CR>
"
"
"   You can put the following lines in your ~/.vimrc in order to invoke
"   GotoFile quickly by hitting <C-f>:
"
"       :nmap <C-f> :GotoFile<CR>
"
"   By default, all the *.o, *.pyc, and */tmp/* files will be ignored, in
"   addition to the wildignore patterns.  You can customize this by setting in
"   your .vimrc:
"
"       let g:GotoFileIgnore = ['*.o', '*.pyc', '*/tmp/*']
"
" CREDITS:
"   Please mail any comment/suggestion/patch to
"   William Lee <wl1012@yahoo.com>
"
" Section: Mappings {{{1
command! -nargs=* -complete=dir GotoFileCache call <SID>CacheDir(<f-args>)
command! -nargs=* -complete=dir GC call <SID>CacheDir(<f-args>)

command! GotoFileCacheClear call <SID>CacheClear()
command! GCC call <SID>CacheClear()

command! GotoFile call <SID>GotoFile()
command! GF call <SID>GotoFile()

command! GotoFileSplit call <SID>GotoFileSplit()
command! GS call <SID>GotoFileSplit()

" Global Settings {{{1
if !exists("g:GotoFileIgnore")
    let g:GotoFileIgnore = ['*.o', '*.pyc', '*/tmp/*']
endif

" Section: Functions {{{1
" File cache to store the filename
let s:fileCache = {}
" Last search results, as displayed to user
let s:results = []

fun! Match(fname, searchTerm)

    let name = "" . a:fname
    let term = "" . a:searchTerm

    let r = { 'mpos': 0, 'mcons': 0 }
    let marker = 0

    let len = strlen(term)
    let i = 0
    let j = 0

    while i < len
        let sc = term[i]

        let idx = stridx(name, sc)

        if idx == -1
            return {}
        endif

        let marker = marker + idx
        let r.mpos = r.mpos + marker

        if idx == 0
            let r.mcons = r.mcons + 1
        endif

        let name = name[idx + 1:]

        let i = i + 1
    endw

    return r

endfun

fun! MatchCompare(i1, i2)

    let m1 = a:i1.match
    let m2 = a:i2.match

    if m1.on == 'file' && m2.on == 'path'
        return -1
    elseif m1.on == 'path' && m2.on == 'file'
        return 1
    endif

    if m1.mcons == m2.mcons
        if m1.mpos == m2.mpos
            return 0
        elseif m1.mpos < m2.mpos
            return -1
        else
            return 1
        endif
        return 0
    elseif m1.mcons > m2.mcons
        return -1
    else
        return 1
    endif

endfun

fun! CompleteFile(findstart, base)
    if a:findstart
        return 0
    endif

    let s:results = []

    for [k, relpath] in items(s:fileCache)
        let matchExpr = <SID>EscapeChars(a:base)
        let fm = Match(k, matchExpr)
        let item = { 'word': a:base, 'abbr': k, 'menu': relpath, 'icase' : 1, 'dup': 1, }
        if has_key(fm, 'mpos')
            let fm.on = 'file'
            let item.match = fm
            call add(s:results, item)
        else
            let pm = Match(relpath, matchExpr)
            if has_key(pm, 'mpos')
                let pm.on = 'path'
                let item.match = pm
                call add(s:results, item)
            endif
        endif
        if complete_check() | break | endif
    endfor

    let s:results = sort(s:results, function('MatchCompare'))

    let i = 0
    for res in s:results
        if i == 0
            let c = '- '
        elseif i == 10
            let c = '0 '
        else
            let c = i . ' '
        endif
        let res['abbr'] = c . res['abbr']
        let i = i + 1
        if i > 10 || complete_check() | break | endif
    endfor

    return s:results

endfun

fun! <SID>GotoFileSplit()
    split
    call <SID>GotoFile()
endfun

fun! <SID>GotoFile()
    if s:fileCache == {}
        echo 'Caching current directory'
        GC .
    endif
    1new GotoFile
    setlocal buftype=nofile
    setlocal bufhidden=hide
    " Map the keys for completion:
    " We are remapping keys from ascii 33 (!) to 126 (~)
    let k = 33
    while (k < 127)
        let c = escape(nr2char(k), "\\'|")
        let remapCmd = "inoremap <expr> <buffer> " . c . " " . "'" . c . "\<C-x>\<C-o>'"
        exe remapCmd
        let k = k + 1
    endwhile
    let remapCmd = "inoremap <expr> <buffer> <BS> '<BS>\<C-x>\<C-o>'"
    exe remapCmd

    inoremap <silent> <buffer> <CR> <ESC>:call <SID>EditFile(0)<CR>
    let k = 1
    while (k < 10)
        let cmd = 'inoremap <silent> <buffer> <C-j>' . k . ' <ESC>:call <SID>EditFile(' . k . ')<CR>'
        exe cmd
        let k = k + 1
    endwhile

    " inoremap <silent> <buffer> <C-j>1 <ESC>:call <SID>EditFile(1)<CR>
    " inoremap <silent> <buffer> <C-j>2 <ESC>:call <SID>EditFile(2)<CR>
    " inoremap <silent> <buffer> <C-j>3 <ESC>:call <SID>EditFile(3)<CR>
    " inoremap <silent> <buffer> <C-j>4 <ESC>:call <SID>EditFile(4)<CR>
    " inoremap <silent> <buffer> <C-j>5 <ESC>:call <SID>EditFile(5)<CR>
    " inoremap <silent> <buffer> <C-j>6 <ESC>:call <SID>EditFile(6)<CR>
    " inoremap <silent> <buffer> <C-j>7 <ESC>:call <SID>EditFile(7)<CR>
    " inoremap <silent> <buffer> <C-j>8 <ESC>:call <SID>EditFile(8)<CR>
    " inoremap <silent> <buffer> <C-j>9 <ESC>:call <SID>EditFile(9)<CR>

    inoremap <silent> <buffer> <C-j>0 <ESC>:call <SID>EditFile(10)<CR>

    inoremap <buffer> <ESC> <ESC>:silent call <SID>QuitBuff()<CR>
    nnoremap <buffer> <ESC> :silent call <SID>QuitBuff()<CR>
    let s:_cot = &completeopt
    set completeopt=menuone
    setlocal omnifunc=CompleteFile
    startinsert
endfun

fun! <SID>CacheClear()
    let s:fileCache = {}
    echo "GotoFile cache cleared."
endfun

fun! <SID>EscapeChars(toEscape)
    return a:toEscape
endfun

fun! <SID>CacheDir(...)
    echo "Finding files to cache..."
    for d in a:000
        "Creates the dictionary that will parse all files recursively
        for i in g:GotoFileIgnore
            exe "setlocal wildignore+=" . i
        endfor
        let files = glob(d . "/**")
        for i in g:GotoFileIgnore
            exe "setlocal wildignore-=" . i
        endfor
        let ctr = 0
        for f in split(files, "\n")
            let fname = fnamemodify(f, ":t")
            " We only glob the files, not directory
            if isdirectory(f) || stridx(system('file ' . f), 'text') == -1
                continue
            endif
            " If the cache already has this entry, we'll just skip it
            let hasEntry = 0
            while has_key(s:fileCache, fname)
                if s:fileCache[fname] == f
                    let hasEntry = 1
                    break
                endif
                let fnameArr = split(fname, ":")
                if len(fnameArr) > 1
                    let fname = fnameArr[0] . ":" . (fnameArr[1] + 1)
                else
                    let fname = fname . ":1"
                endif
            endwhile
            if !hasEntry
                let s:fileCache[fname] = f
                let ctr = ctr + 1
            endif
        endfor
        echo "Found " . ctr . " new files in '" . d . "'. Cache has " . len(s:fileCache) . " entries.\n"
    endfor
endfun

fun! <SID>EditFile(n)
    " Closes the buffer
    let fileToOpen = s:results[a:n].menu
    if filereadable(fileToOpen)
        call <SID>QuitBuff()
        silent exe "edit " . fileToOpen
        echo "File: " . fileToOpen
    else
        echo "File " . fileToOpen . " not found. Run ':GotoFileCache .' or ':GC .' to refresh if necessary."
    endif
endfun

fun! <SID>QuitBuff()
    let &completeopt=s:_cot
    silent exe "bd!"
endfun
