module.exports = (grunt) ->
	path = require("path")

	grunt.initConfig(
		pkg: grunt.file.readJSON('package.json'),
		gruntconfig: do ->
			cfg =
				out: "out"
				release: "release"
				debug: "debug"
			try
				cfg = grunt.file.readJSON('gruntconfig.json')
			catch err
				grunt.log.writeln err
			cfg
		
		components: "components"
		resource:
			root: "<%= gruntconfig.out %>"
			path: "<%= resource.root %>"
			www: "www"
			js: "<%= resource.www %>/js"
			lib: "<%= resource.js %>/lib"			
			css: "<%= resource.www %>/css"
			img: "<%= resource.www %>/img"
			sounds: "<%= resource.www %>/sounds"

		less:
			common:
				files:
					"<%= resource.root %>/<%= gruntconfig.debug %>/<%= resource.css %>/reset.css": "static/less/reset.less"
					"<%= resource.root %>/<%= gruntconfig.debug %>/<%= resource.css %>/style.css": "static/less/style.less"

		clean:
			files:
				src:["<%= resource.root %>"]
			options:
				force: true

		coffee:
			common:
				expand: true
				src: ["*.coffee", "**/*.coffee", "**/**/*.coffee"]
				cwd: "static/coffee/"
				dest: "<%= resource.root %>/<%= gruntconfig.debug %>/<%= resource.js %>/"
				ext: '.js'
				options:
					bare: true

		requirejs:
			common:
				options:
					name: "app"
					baseUrl: "<%= resource.root %>/<%= gruntconfig.debug %>/<%= resource.js %>/"
					mainConfigFile: "<%= resource.root %>/<%= gruntconfig.debug %>/<%= resource.js %>/config.js"
					out: "<%= resource.root %>/<%= gruntconfig.release %>/<%= resource.js %>/main.js"

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
			img_shell: 
				files: "static/img/**"
				tasks: ["copy:img"]

		copy:
			html:files: [
				flattern: true
				expand: true
				src: "*.html"
				cwd: "static/html"
				dest: "<%= resource.root %>/<%= gruntconfig.debug %>/<%= resource.www %>"
			]
			img:files: [
				flattern: true
				expand: true
				src: ["**"]
				cwd: "static/img"
				dest: "<%= resource.root %>/<%= gruntconfig.debug %>/<%= resource.img %>"
			]
			sounds:files: [
				flattern: true
				expand: true
				src: ["*.ogg", "*.wav"]
				cwd: "static/sounds"
				dest: "<%= resource.root %>/<%= gruntconfig.debug %>/<%= resource.sounds %>"
			]
			jquery:files:[
				flattern: true
				expand: true
				src: "jquery.js"
				cwd: "<%= components %>/jquery/"
				dest: "<%= resource.root %>/<%= gruntconfig.debug %>/<%= resource.lib %>/jquery/"
			]
			requirejs:files:[
				flattern: true
				expand: true
				src: "require.js"
				cwd: "<%= components %>/requirejs/"
				dest: "<%= resource.root %>/<%= gruntconfig.debug %>/<%= resource.lib %>/requirejs/"
			]
			backbone:files:[
				flattern: true
				expand: true
				src: "backbone.js"
				cwd: "<%= components %>/backbone/"
				dest: "<%= resource.root %>/<%= gruntconfig.debug %>/<%= resource.lib %>/backbone/"
			,
				flattern: true
				expand: true
				src: "underscore.js"
				cwd: "<%= components %>/underscore"
				dest: "<%= resource.root %>/<%= gruntconfig.debug %>/<%= resource.lib %>/underscore"
			]

		compress: 
			main:
				options:
					archive: '<%= resource.root %>/build.zip'
				files:
					src: ['<%= resource.www %>/**']

		cssmin:
  			minify: 
    			expand: true
    			cwd: "<%= resource.root %>/<%= gruntconfig.debug %>/<%= resource.css %>"
    			src: ['*.css', '!*.min.css']
    			dest: "<%= resource.root %>/<%= gruntconfig.release %>/<%= resource.css %>"
    			ext: '.css'

		connect:
			dev:
				options:
					hostname: '*'
					port: 9090 
					base: "<%= resource.root %>/<%= gruntconfig.debug %>/<%= resource.www %>"

			release:
				options:
					hostname: '*'
					port: 9090
					base: "<%= resource.root %>/<%= gruntconfig.release %>/<%= resource.www %>"
					keepalive: true
	)

	grunt.registerTask('css-build-dev', ['less'])
	grunt.registerTask('css-build', ['css-build-dev', 'cssmin:minify'])
	grunt.registerTask('js-build-dev', ['coffee'])
	grunt.registerTask('js-build', ['coffee'])
	grunt.registerTask('build-dev', ['css-build-dev', 'js-build-dev'])
	grunt.registerTask('build', ['css-build', 'js-build'])

	grunt.registerTask('debug', ['clean', 'copy', 'build-dev', 'connect:dev', 'watch'])
	grunt.registerTask('release', ['clean', 'copy', 'build', 'connect:release'])

	grunt.loadNpmTasks "grunt-contrib-clean"
	grunt.loadNpmTasks "grunt-contrib-less"
	grunt.loadNpmTasks "grunt-contrib-coffee"
	grunt.loadNpmTasks "grunt-contrib-concat"
	grunt.loadNpmTasks "grunt-contrib-copy"
	grunt.loadNpmTasks "grunt-contrib-requirejs"
	grunt.loadNpmTasks "grunt-contrib-connect"
	grunt.loadNpmTasks "grunt-contrib-watch"
	grunt.loadNpmTasks "grunt-contrib-compress"
	grunt.loadNpmTasks "grunt-contrib-cssmin"
