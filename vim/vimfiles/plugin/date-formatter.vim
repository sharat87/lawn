nnoremap cdo :call <SID>DateReformat('%d-%b-%Y')<CR>
nnoremap cda :call <SID>DateReformat('%m/%d/%Y')<CR>
nnoremap cdi :call <SID>DateReformat('%Y-%m-%d')<CR>

fun! s:DateReformat(to_fmt) abort
  py3 <<EOPYTHON
import vim, re, datetime

to_fmt = vim.eval('a:to_fmt')

patterns = [
  r'(?P<month>\d\d?)/(?P<day>\d\d?)/(?P<year>\d{4})',
  r'(?P<year>\d{4})-(?P<month>\d\d)-(?P<day>\d\d)/',
  r'(?P<year>\d{4})-(?P<month>\w{3})-(?P<day>\d\d)/',
]

MONTHS = {
  'jan': 1,
  'feb': 2,
  'mar': 3,
  'apr': 4,
  'may': 5,
  'jun': 6,
  'jul': 7,
  'aug': 8,
  'sep': 9,
  'oct': 10,
  'nov': 11,
  'dec': 12,
}

line = vim.current.line

match = None
for pat in patterns:
  match = re.search(pat, line)
  if match:
    break

if match:
  vals = match.groupdict()
  if 'month' in vals and not vals['month'].isdigit():
    vals['month'] = MONTHS[vals['month'][:3].lower()]
  now = datetime.datetime.now()
  dt = datetime.datetime(int(vals.get('year', now.year)), int(vals.get('month', now.month)), int(vals.get('day', now.day)))
  start, end = match.span()
  vim.current.range[0] = line[:start] + dt.strftime(to_fmt) + line[end + 1:]
  vim.command("echomsg '" + repr(dt) + "'")
else:
  vim.command("echomsg 'No match'")
EOPYTHON
endfun

" Test bed
" 4/20/2018
" 2018-04-20
