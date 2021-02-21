" Check for upload files.
" TODO: Not working.
let s:headers =<< trim EOHEADERS
Action,Date,Index,Component,Comp Type,Asset Type,Attribute,Attribute Value,Value Type,Set Name,Lead Lag Days,From Date,To Date
EOHEADERS

if index(s:headers, substitute(getline(1), "\t", ',', 'g'), 1) >= 0
	set ft=csv
endif
