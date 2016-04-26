'use strict';

module.exports = function(grunt) {

  // Project configuration.
  grunt.initConfig({
    nodeunit: {
      files: ['test/**/*_test.js'],
    },
    jshint: {
      options: {
        jshintrc: '.jshintrc'
      },
      gruntfile: {
        src: 'Gruntfile.js'
      },
      lib: {
        src: ['lib/**/*.js']
      },
      test: {
        src: ['test/**/*.js']
      },
    },
    watch: {
      gruntfile: {
        files: '<%= jshint.gruntfile.src %>',
        tasks: ['jshint:gruntfile']
      },
      lib: {
        files: '<%= jshint.lib.src %>',
        tasks: ['jshint:lib', 'nodeunit']
      },
      test: {
        files: '<%= jshint.test.src %>',
        tasks: ['jshint:test', 'nodeunit']
      },
      coffeefiles: {
        files: ['app/assets/javascripts/*.js*'],
        options: {
          livereload: true,
        }
      },
      // reload on *html file change
      templatefiles: {
        files: ['app/assets/javascripts/*.html'],
        options: {
          livereload: true,
        }
      },
      // reload on erb file change
      erbfiles: {
        files: ['app/views/{,*/}*.erb'],
        options: {
          livereload: true
        }
      },
      // reload on CSS file change
      cssfiles: {
        files: ['app/assets/stylesheets/*.css'],
        options: {
          livereload: true,
        }
      },
      // reload on SCSS files change
      scssfiles: {
        files: ['app/assets/stylesheets/*.scss'],
        options: {
          livereload: true,
        }
      },
      // reload on any change in stylesheets
      scssfoldersfiles: {
        files: ['app/assets/stylesheets/*/*.scss'],
        options: {
          livereload: true,
        }
      }

    },
  });

  // // These plugins provide necessary tasks.
  grunt.loadNpmTasks('grunt-contrib-nodeunit');
  grunt.loadNpmTasks('grunt-contrib-jshint');
  grunt.loadNpmTasks('grunt-contrib-watch');

  // Default task.
  grunt.registerTask('default', ['jshint', 'nodeunit']);

};