function! s:XMLPrettify()

    python3 <<EOPYTHON
import vim
from xml.dom import minidom
from xml.etree import ElementTree

def sort_children(element):
    element[:] = list(sorted(element, key=lambda child: child.tag))
    for child in element:
        sort_children(child)

content = ''.join(vim.current.buffer)
tree = ElementTree.XML(content)
sort_children(tree)
xml = minidom.parseString(ElementTree.tostring(tree))
vim.current.buffer[:] = xml.toprettyxml().split('\n')
EOPYTHON

endfunction

nnoremap <buffer> <silent> <LocalLeader>x :call <SID>XMLPrettify()<CR>
