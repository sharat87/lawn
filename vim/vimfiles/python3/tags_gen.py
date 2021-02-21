import re
from glob import iglob as glob


def find_files_to_process(root, patterns):
    for pat in patterns:
        yield from glob(root + '/' + pat)
        yield from glob(root + '/**/' + pat)


def generate(root, patterns, tags_file):
    tags = []

    for path in find_files_to_process(root, patterns):
        if path.endswith('.md'):
            tags.extend(ft_markdown(path))
        elif path.endswith('.py'):
            tags.extend(ft_python(path))

    with open(tags_file, 'w', encoding='utf-8') as f:
        f.write('\n'.join(tags))


def ft_markdown(path):
    tags = []
    with open(path, encoding='utf-8-sig') as f:
        for l, line in enumerate(f, start=1):
            if line.startswith('#'):
                tags.append(f'{line[:-1]}\t{path}\t{l}')
    return tags


def ft_python(path):
    tags = []
    def_pat = re.compile(r'^\s*(?P<type>def|class)\s+(?P<name>[a-zA-Z_][a-zA-Z0-9_]+)', re.VERBOSE)
    cls_stack = []
    in_def = False

    with open(path, encoding='utf-8-sig') as f:
        for l, line in enumerate(f, start=1):
            match = def_pat.match(line)
            if match is None:
                continue

            is_def = match.group('type') == 'def'
            if not is_def:
                cls_stack.append(match.group('name'))

            name = (('.'.join(cls_stack) + '.') if cls_stack else '') + match.group('name')
            tags.append(f'{line[:-1]}\t{path}\t{l}')

    return tags


def _main():
    generate(
        sys.argv[1],
        [pat.strip() for pat in sys.argv[2].split(',')],
        sys.argv[3] if len(sys.argv) > 3 else 'tags',
    )


if __name__ == '__main__':
    _main()
