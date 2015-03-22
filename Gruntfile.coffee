module.exports = (grunt) ->

  grunt.loadNpmTasks 'grunt-coffeelint'
  grunt.loadNpmTasks 'grunt-contrib-clean'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-mocha-test'

  grunt.initConfig
    pkg: grunt.file.readJSON 'package.json'

    watch:
      options:
        spawn: false
        interval: 10

      tasks: ['test']
      files: [
        '<%= pkg.directories.src %>/**/**'
        '<%= pkg.directories.test %>/**/**'
      ]

    clean: ['<%= pkg.directories.lib %>/*']

    coffeelint:
      options: configFile: 'coffeelint.json'
      files: [
        'Gruntfile.coffee'
        '<%= pkg.directories.src %>/**/*.coffee'
        '<%= pkg.directories.src %>/**/*.litcoffee'
        '<%= pkg.directories.test %>/**/*.coffee'
        '<%= pkg.directories.test %>/**/*.litcoffee'
      ]

    mochaTest:
      options:
        bail: true
        clearRequireCache: true
        reporter: 'spec'
        require: 'coffee-script/register'

      unit:
        src: [
          '<%= pkg.directories.test %>/unit/*.coffee'
          '<%= pkg.directories.test %>/unit/*.litcoffee'
        ]

      functional:
        src: [
          '<%= pkg.directories.test %>/functional/*.coffee'
          '<%= pkg.directories.test %>/functional/*.litcoffee'
        ]

    coffee:
      options: bare: true
      compile:
        files: [
          expand: true
          cwd: '<%= pkg.directories.src %>/'
          src: ['**/*.coffee', '**/*.litcoffee']
          dest: '<%= pkg.directories.lib %>/'
          ext: '.js'
        ]

  # On watch events, if the changed file is a test file then configure
  # mochaTest to only run the tests from that file. Otherwise run all the
  # tests
  #
  defaultLintFiles = grunt.config 'coffeelint.files'
  defaultUnitSrc = grunt.config 'mochaTest.unit.src'
  defaultFunctionalSrc = grunt.config 'mochaTest.functional.src'

  grunt.event.on 'watch', (action, filepath) ->
    if /test\/unit/.test filepath
      grunt.config 'coffeelint.files', filepath
      grunt.config 'mochaTest.unit.src', filepath
      grunt.config 'mochaTest.functional.src', []

    else if /test\/functional/.test filepath
      grunt.config 'coffeelint.files', filepath
      grunt.config 'mochaTest.unit.src', []
      grunt.config 'mochaTest.functional.src', filepath

    else
      grunt.config 'coffeelint.files', defaultLintFiles
      grunt.config 'mochaTest.unit.src', defaultUnitSrc
      grunt.config 'mochaTest.functional.src', defaultFunctionalSrc

  grunt.registerTask 'default', ['build']
  grunt.registerTask 'build', ['clean', 'coffee:compile']
  grunt.registerTask 'test', ['coffeelint', 'mochaTest']

