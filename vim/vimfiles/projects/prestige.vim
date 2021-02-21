if ! isdirectory(expand('~/labs/prestige'))
	echoerr 'Cannot find the Prestige project.'
	finish
endif

cd ~/labs/prestige

command ServeBackend tab call term_start(
			\ 'make serve-backend',
			\ {'term_name': 'Backend Server', 'term_kill': 'int'}
			\ )

command TestBackend tab call term_start(
			\ 'make test-backend',
			\ {'term_name': 'Backend Tests', 'term_kill': 'int'}
			\ )

command ServeFrontend tab call term_start(
			\ 'make serve-frontend',
			\ {'term_name': 'Frontend Server', 'term_kill': 'int'}
			\ )

command TestFrontend tab call term_start(
			\ 'make test-frontend',
			\ {'term_name': 'Frontend Tests', 'term_kill': 'int'}
			\ )
