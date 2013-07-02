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
			css: "<%= resource.path %>/css"
			less: "<%= resource.path %>/less"
			img: "<%= resource.path %>/img"
			font: "<%= resource.path %>/font"
			templates: "<%= resource.path %>/templates"
			build: "<%= resource.path %>/build"
			html: "<%= resource.root %>/<%= gruntconfig.html %>"

		less:
			common:
				files:
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
	)

	grunt.registerTask('default', [])
	grunt.registerTask('dev', [])

	grunt.loadNpmTasks "grunt-contrib-clean"
	grunt.loadNpmTasks "grunt-contrib-less"
	grunt.loadNpmTasks "grunt-contrib-coffee"
	grunt.loadNpmTasks "grunt-contrib-concat"
	grunt.loadNpmTasks "grunt-contrib-requirejs"