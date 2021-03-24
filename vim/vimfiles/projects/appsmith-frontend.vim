if ! isdirectory(expand('~/work/appsmith-its/app/client'))
	echoerr 'Cannot find the Appsmith client project.'
	finish
endif

cd ~/work/appsmith-its/app/client
