finish

" Disable spell checking for acronyms.
syn match acronyms ?\C\<[A-Z0-9]\+\>? contains=@NoSpell

" YAML front matter between triple dashes. The ending `---` can be substituted with `...`.
syntax include @yaml syntax/yaml.vim
syntax region yamlFrontMatter start=/\v%^---$/ end=/\v^%(.{3}|-{3})$/ keepend contains=@yaml
