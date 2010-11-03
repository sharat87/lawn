function <SID>HgStatus()
    redir => status_out
    !hg st
    redir END
    if status_out == ''
        echo 'No changes'
    else
        new
        normal "=status_out<CR>p
    endif
endfunction

command Mstatus :call <SID>HgStatus()
