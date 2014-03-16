let current_compiler = 'jshint'
CompilerSet makeprg=jshint\ --verbose\ %\ \|\ head\ -n-2
CompilerSet errorformat=%f:\ line\ %l\\,\ col\ %c\\,\ %m\ (%t%n)
