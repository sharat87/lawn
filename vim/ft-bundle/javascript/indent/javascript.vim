" Vim indent file
" Language:	JavaScript
" Author:	Ryan (ryanthe) Fabella <ryanthe at gmail dot com>
" URL:		-
" Last Change:  2007 september 25

if exists('b:did_indent')
    finish
endif
let b:did_indent = 1

setlocal indentexpr=GetJsIndent()
setlocal indentkeys=0{,0},0),:,!^F,o,O,e,*<Return>,=*/
" Clean CR when the file is in Unix format
if &fileformat == "unix" 
    silent! %s/\r$//g
endif
" Only define the functions once per Vim session.
if exists("*GetJsIndent")
    finish 
endif
function! GetJsIndent()
    let pnum = prevnonblank(v:lnum - 1)
    if pnum == 0
        return 0
    endif
    let line = getline(v:lnum)
    let pline = getline(pnum)
    let ind = indent(pnum)

    " Prev. line ends with an { or [ or (
    if pline =~ '{\s*$\|[\s*$\|(\s*$'
        let ind = ind + &sw
    endif

    " Prev. line ends with a ; and current line begins with a }
    if pline =~ ';\s*$' && line =~ '^\s*}'
        let ind = ind - &sw
    endif

    " Prev. line ends with ] and current line is `),`
    if pline =~ '\s*]\s*$' && line =~ '^\s*),\s*$'
        let ind = ind - &sw
    endif

    " Prev. line ends with ] and current line is }
    if pline =~ '\s*]\s*$' && line =~ '^\s*}\s*$'
        let ind = ind - &sw
    endif

    " Prev. line is }); or ); and does not end with ;
    if line =~ '^\s*});\s*$\|^\s*);\s*$' && pline !~ ';\s*$'
        let ind = ind - &sw
    endif

    " Current line starts with }) and prev. line ends with ,
    if line =~ '^\s*})' && pline =~ '\s*,\s*$'
        let ind = ind - &sw
    endif

    " Current line is }(); and prev. line is }
    if line =~ '^\s*}();\s*$' && pline =~ '^\s*}\s*$'
        let ind = ind - &sw
    endif

    " Current line is }),
    if line =~ '^\s*}),\s*$'
        let ind = ind - &sw
    endif

    " Prev. line is } and current line ends with ),
    if pline =~ '^\s*}\s*$' && line =~ '),\s*$'
        let ind = ind - &sw
    endif

    " Prev. line starts with for and current line ends with )
    if pline =~ '^\s*for\s*' && line =~ ')\s*$'
        let ind = ind + &sw
    endif

    if line =~ '^\s*}\s*$\|^\s*]\s*$\|\s*},\|\s*]);\s*\|\s*}]\s*$\|\s*};\s*$\|\s*})$\|\s*}).el$' && pline !~ '\s*;\s*$\|\s*]\s*$' && line !~ '^\s*{' && line !~ '\s*{\s*}\s*'
        let ind = ind - &sw
    endif

    if pline =~ '^\s*var\s*.*,\s*$'
        let ind = ind + &sw
    end

    if line =~ '^\s*\..*$' && pline !~ '^\s*\..*$'
        let ind = ind + &sw
    endif

    if pline =~ '^\s*\..*$' && pline =~ ';\s*$'
        let ind = ind - &sw
    endif

    if pline =~ '^\s*/\*'
        let ind = ind + &sw
    endif

    if pline =~ '\*/$'
        let ind = ind - &sw
    endif
    return ind
endfunction
