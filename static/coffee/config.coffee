requirejs.config(
	baseUrl: 'js',
	paths: 
		underscore: '/lib/underscore/underscore'
		backbone: '/lib/backbone/backbone'
		jquery: '/lib/jquery/jquery'
	shim:
		jquery: 
			exports: 'jQuery'
		backbone:
			deps: ['underscore', 'jquery']
			exports: 'Backbone'
		underscore:
			exports: '_'
)