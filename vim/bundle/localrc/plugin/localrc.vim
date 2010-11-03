" Set directory-wise configuration.
" Search from the directory the file is located upwards to the root for
" a local configuration file called .lvimrc and sources it.
"
" The local configuration file is expected to have commands affecting
" only the current buffer.

let s:lvimrcs = [".lvimrc", "lvimrc", "lvimrc.vim"]

function <SID>SetLocalOptions()
    let dirname = fnamemodify(bufname("%"), ":p:h")
    let found = 0
    while "/" != dirname && !found
        for rcname in s:lvimrcs
            let lvimrc  = dirname . "/" . rcname
            if filereadable(lvimrc)
                execute "source " . lvimrc
                let found = 1
                break
            endif
        endfor
        let dirname = fnamemodify(dirname, ":p:h:h")
    endwhile
endfunction

command! Lvimrc call <SID>SetLocalOptions()

au BufNewFile,BufRead * Lvimrc
