requirejs.config(
	baseUrl: 'components',
	paths: 
		underscore: 'underscore/underscore'
		backbone: 'backbone/backbone'
		jquery: 'jquery/jquery'
	shim:
		jquery: 
			exports: 'jQuery'
		backbone:
			deps: ['underscore', 'jquery']
			exports: 'Backbone'
		underscore:
			exports: '_'
)