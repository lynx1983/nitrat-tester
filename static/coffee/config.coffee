requirejs.config(
	baseUrl: 'js',
	paths: 
		underscore: 'lib/underscore/underscore'
		backbone: 'lib/backbone/backbone'
		jquery: 'lib/jquery/jquery'
		underi18n: 'lib/underi18n/underi18n'
	shim:
		jquery: 
			exports: 'jQuery'
		backbone:
			deps: ['underscore', 'jquery']
			exports: 'Backbone'
		underscore:
			exports: '_'
		underi18n:
			exports: 'underi18n'
)