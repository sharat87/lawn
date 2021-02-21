import vim

# Setup `vartabstop` so that columns line up.
vim.command('command! TabsLineUp py3 ' + __name__ + '.tabs_line_up()')


def tabs_line_up():
    lengths = []

    for line in vim.current.buffer:
        if '\t' not in line:
            continue
        parts = line.split('\t')
        lengths.append([len(c) for c in parts])

    vim.current.buffer.options['vartabstop'] = ','.join(str(max(ls) + 3) for ls in zip(*lengths))
