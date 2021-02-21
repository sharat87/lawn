import re
import textwrap
import vim


def format_any():
    mode = vim.eval('mode()')
    if mode in 'iR':
        # Use default formatter when in insert/replace mode.
        return 1

    top = int(vim.eval('v:lnum')) - 1
    bottom = top + int(vim.eval('v:count'))
    tw = int(vim.eval('&tw'))
    lines_old = vim.current.buffer[top:bottom]
    vim.current.buffer[top:bottom] = textwrap.wrap(' '.join(lines_old), width=tw)
    return 0


def format_table():
    top = int(vim.eval('''getpos("'{")''')[1])
    bot = int(vim.eval('''getpos("'}")''')[1]) - 1
    while vim.current.buffer[bot] == '':
        bot -= 1

    lines = vim.current.buffer[top:bot + 1]

    if re.search('[^-| ]', lines[1]):
        lines.insert(1, '')

    widths = []
    matrix = []

    # Loop for calculating column widths.
    for i, line in enumerate(lines):
        if i != 1:
            if not line.startswith('|'):
                lines[i] = '| ' + lines[i]
            if not line.endswith('|'):
                lines[i] += ' |'
            line = lines[i]

        matrix.append([c.strip() for c in line.strip('|').split('|')])
        if i != 1:
            for j, col in enumerate(matrix[i]):
                if j < len(widths):
                    widths[j] = max(widths[j], len(col))
                else:
                    widths.append(len(col))

    # Aligning loop.
    for i, line in enumerate(lines):
        cols = []
        for j, col in enumerate(matrix[i]):
            cols.append(col + ' ' * (widths[j] - len(col)))
        for w in widths[j + 1:]:
            cols.append(' ' * w)
        lines[i] = '| ' + ' | '.join(cols) + ' |'

    # Render the header's underline.
    lines[1] = '| ' + ' | '.join('-' * w for w in widths) + ' |'

    if lines != vim.current.buffer[top:bot + 1]:
        vim.current.buffer[top:bot + 1] = lines
