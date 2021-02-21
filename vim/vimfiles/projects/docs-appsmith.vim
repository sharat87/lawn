if ! isdirectory(expand('~/work/appsmith-docs'))
	echoerr 'Cannot find the Appsmith docs project.'
	finish
endif

cd ~/work/appsmith-docs
