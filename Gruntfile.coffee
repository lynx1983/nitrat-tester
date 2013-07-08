module.exports = (grunt) ->
	path = require("path")

	grunt.initConfig(
		pkg: grunt.file.readJSON('package.json'),
		gruntconfig: do ->
			cfg =
				static_folder: "/resources/"
				root: "www"
			try
				cfg = grunt.file.readJSON('gruntconfig.json')
			catch err
				grunt.log.writeln err
			cfg
		
		components: "components"
		static_folder: "<%= gruntconfig.static_folder %>"
		resource:
			root: "<%= gruntconfig.root %>"
			path: "<%= resource.root %>"
			js: "<%= resource.path %>/js"
			lib: "<%= resource.js %>/lib"			
			css: "<%= resource.path %>/css"
			less: "<%= resource.path %>/less"
			img: "<%= resource.path %>/img"
			font: "<%= resource.path %>/font"
			templates: "<%= resource.path %>/templates"
			build: "<%= resource.path %>/build"

		less:
			common:
				files:
					"<%= resource.css %>/reset.css": "static/less/reset.less"
					"<%= resource.css %>/style.css": "static/less/style.less"

		clean:
			files:
				src:["<%= resource.path %>"]
			options:
				force: true

		coffee:
			common:
				expand: true
				src: ["*.coffee", "**/*.coffee", "**/**/*.coffee"]
				cwd: "static/coffee/"
				dest: "<%= resource.js %>/"
				ext: '.js'
				options:
					bare: true

		requirejs:
			common:
				options:
					name: "app"
					baseUrl: "<%= resource.js %>/"
					mainConfigFile: "<%= resource.js %>/config.js"
					out: "<%= resource.js %>/main-<%= pkg.name %>-<%= pkg.version %>.js"

		watch:
			coffee_shell:
				files: ["static/coffee/*.coffee", "static/coffee/**/*.coffee"]
				tasks: ["coffee"]
			less_shell:
				files: "static/less/*.less"
				tasks: ["less"]
			html_shell: 
				files: "static/html/*.html"
				tasks: ["copy:html"]

		copy:
			html:files: [
				flattern: true
				expand: true
				src: "*.html"
				cwd: "static/html"
				dest: "<%= resource.path %>"
			]
			img:files: [
				flattern: true
				expand: true
				src: ["*.png", "*.jpg"]
				cwd: "static/img"
				dest: "<%= resource.img %>"
			]
			jquery:files:[
				flattern: true
				expand: true
				src: "jquery.js"
				cwd: "<%= components %>/jquery/"
				dest: "<%= resource.lib %>/jquery/"
			]
			requirejs:files:[
				flattern: true
				expand: true
				src: "require.js"
				cwd: "<%= components %>/requirejs/"
				dest: "<%= resource.lib %>/requirejs/"
			]
			backbone:files:[
				flattern: true
				expand: true
				src: "backbone.js"
				cwd: "<%= components %>/backbone/"
				dest: "<%= resource.lib %>/backbone/"
			,
				flattern: true
				expand: true
				src: "underscore.js"
				cwd: "<%= components %>/underscore"
				dest: "<%= resource.lib %>/underscore"
			]

		compress: 
			main:
				options:
					archive: 'build.zip'
				files:
					src: ['www/**']

		connect:
			dev:
				options:
					hostname: '*'
					port: 9090 
					base: "<%= resource.path %>"

			release:
				options:
					hostname: '*'
					port: 9090
					base: "<%= connect.dev.base %>"
					keepalive: true
	)

	grunt.registerTask('css-build', ['less'])
	grunt.registerTask('js-build', ['coffee'])
	grunt.registerTask('build-dev', ['css-build', 'js-build'])

	grunt.registerTask('default', [])
	grunt.registerTask('dev', ['clean', 'copy', 'build-dev', 'connect:dev', 'watch'])

	grunt.loadNpmTasks "grunt-contrib-clean"
	grunt.loadNpmTasks "grunt-contrib-less"
	grunt.loadNpmTasks "grunt-contrib-coffee"
	grunt.loadNpmTasks "grunt-contrib-concat"
	grunt.loadNpmTasks "grunt-contrib-copy"
	grunt.loadNpmTasks "grunt-contrib-requirejs"
	grunt.loadNpmTasks "grunt-contrib-connect"
	grunt.loadNpmTasks "grunt-contrib-watch"
	grunt.loadNpmTasks "grunt-contrib-compress"
