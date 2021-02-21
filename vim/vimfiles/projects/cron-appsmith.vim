if ! isdirectory(expand('~/work/cron/'))
	echoerr 'Cannot find the appsmith cron project.'
	finish
endif

cd ~/work/cron
