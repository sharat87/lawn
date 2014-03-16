let current_compiler = 'frosted'

CompilerSet makeprg=frosted\ -vb\ %

CompilerSet errorformat=
    \%f:%l:%c:%m,
    \%E%f:%l:\ %m,
    \%-Z%p^,
    \%-G%.%#
