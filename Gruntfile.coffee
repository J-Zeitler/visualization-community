# Grunt utils

# path = require 'path'

module.exports = (grunt) ->
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-rerun'
  grunt.loadNpmTasks 'grunt-express-server'
  grunt.loadNpmTasks 'grunt-mocha-test'

  grunt.initConfig
    watch:
      # watch coffee files in client directory
      clientCoffee:
        files: 'client/scripts/**/*.coffee'
        tasks: ['coffee:compileClient']

      # watch coffee files in client directory
      serverCoffee:
        files: 'server/scripts/**/*.coffee'
        tasks: ['coffee:compileServer']

      express:
        files: [ 'server/js/**/*.js' ]
        tasks: [ 'express:dev' ]
        options:
          spawn: false

    # tests
    mochaTest:
      test:
        options:
          reporter: 'spec'
        src: ['test/**/*.js']

    # compile coffee
    coffee:
      compileClient:
        expand: true
        flatten: true
        cwd: "#{__dirname}/client/scripts/"
        src: ['**/*.coffee']
        dest: 'client/js/'
        ext: '.js'

      compileServer:
        expand: true
        flatten: false # keep directory srtucture on server side
        cwd: "#{__dirname}/server/scripts/"
        src: ['**/*.coffee']
        dest: 'server/js/'
        ext: '.js'

      compileTest:
        expand: true
        flatten: false # keep directory srtucture on server side
        cwd: "#{__dirname}/test/scripts/"
        src: ['**/*.coffee']
        dest: 'test/js/'
        ext: '.js'

    # run server
    express:
      dev:
        options:
          script: 'server/js/server.js'

    # rerun server
    # rerun:
    #   dev:
    #     options:
    #       tasks: ['express']
      
  grunt.registerTask 'default', ['coffee:compileServer', 'coffee:compileClient', 'express', 'watch']
  grunt.registerTask 'test', ['coffee:compileServer', 'coffee:compileClient', 'coffee:compileTest', 'mochaTest']