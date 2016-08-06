module.exports = function (grunt) {

	'use strict';

	grunt.initConfig({

		path_build_less: 'build/less',
		path_build_js: 'build/js',
		path_cdn_css: 'cdn/frontend-css',
		path_cdn_js: 'cdn/frontend-js',

		clean: {
			dist: [
				'<%= path_cdn_css %>/*.css',
				'<%= path_cdn_js %>/*.js'
			]
		},

		concat: {
			dist: {
				src: [
					'<%= path_build_js %>/prefs.js',
					'<%= path_build_js %>/lib.js',
					'<%= path_build_js %>/layout.js',
					'<%= path_build_js %>/ui.js',
					'<%= path_build_js %>/instance.js',
					'<%= path_build_js %>/methods.js',
					'<%= path_build_js %>/main.js'
				],
				dest: '<%= path_cdn_js %>/pinup.js'
			}
		},

		jshint: {
			options: {
				jshintrc: '.jshintrc'
			},
			dist: [
				'Gruntfile.js',
				'<%= path_cdn_js %>/*.js',
				'!<%= path_cdn_js %>/*.min.js'
			]
		},

		uglify: {
			dist: {
				files: {
					'<%= path_cdn_js %>/pinup.min.js': '<%= path_cdn_js %>/pinup.js'
				}
			}
		},

		less: {
			dist: {
				files: {
					'<%= path_cdn_css %>/pinup.css': '<%= path_build_less %>/all.less'
				}
			}
		},

		cssmin: {
			options: {
				keepSpecialComments: 0,
				keepBreaks: true,
				removeEmpty: true
			},
			minify: {
				expand: true,
				cwd: '<%= path_cdn_css %>',
				src: ['*.css', '!*.min.css'],
				dest: '<%= path_cdn_css %>',
				ext: '.min.css'
			}
		},

		watch: {

			js: {
				files: [
					'<%= path_build_js %>/*.js'
				],
				tasks: ['jshint', 'uglify'],
				options: {
					spawn: false,
					livereload: true
				}
			},
			
			less: {
				files: [
					'<%= path_build_less %>/*.less'
				],
				tasks: ['less', 'cssmin']
			},

			css: {
				files: [
					'<%= path_cdn_css %>/*.min.css'
				],
				options: {
					spawn: false,
					livereload: true
				}
			}
		},

	});

	grunt.loadNpmTasks('grunt-contrib-clean');
	grunt.loadNpmTasks('grunt-contrib-watch');
	grunt.loadNpmTasks('grunt-contrib-less');
	grunt.loadNpmTasks('grunt-contrib-cssmin');
	grunt.loadNpmTasks('grunt-contrib-jshint');
	grunt.loadNpmTasks('grunt-contrib-uglify');
	grunt.loadNpmTasks('grunt-contrib-concat');

	grunt.registerTask('default', [
		'clean',
		'concat',
		'jshint',
		'uglify',
		'less',
		'cssmin'
	]);

};
