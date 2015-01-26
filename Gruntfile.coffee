Handlebars = require 'handlebars'
chalk      = require 'chalk'

module.exports = (grunt) ->

  fileSet = (dir, ext, newExt=undefined) -> if newExt? then [
    expand : true
    cwd    : dir
    src    : ["**/*.#{ext}"]
    dest   : "build/#{dir}"
    ext    : newExt
  ] else [
    expand : true
    cwd    : dir
    src    : ["**/*.#{ext}"]
    dest   : "build/#{dir}"
  ]

  # Grunt task to compile schedules from CSV files into javascript files to be
  # served to the web app
  grunt.registerMultiTask 'schedule', 'Compile CSV schedules to javscript', () ->
    count = 0
    @files.forEach (fileSet) ->
      destFile = fileSet.dest

      filtered = fileSet.src.filter (filePath) ->
        if grunt.file.exists filePath
          return true
        else
          grunt.log.warn 'Source file "' + filePath + '" not found.'
          return false;

      if filtered.length is 0
        if fileSet.src.length < 1
          grunt.log.warn 'Destination ' + chalk.cyan(destFile) +
            ' not written because no source files were found.'
        return

      filtered.forEach (filePath) ->
        contents = grunt.file.read filePath
        {name, compiled} = CSV.compile grunt, filePath, contents
        if compiled.length == 0
          grunt.log.warn 'Destination ' + chalk.cyan(destFile) +
            ' not written because source files were empty.'
        else
          grunt.file.write destFile, compiled
          count++
    grunt.log.ok "#{count} #{grunt.util.pluralize(count, 'file/files')} created."

  # Grunt task to compile
  grunt.registerMultiTask 'html', 'Compile HTML templates', () ->
    options = getHtmlCompileOptions grunt
    count = 0
    @files.forEach (fileSet) ->
      destFile = fileSet.dest
      filtered = fileSet.src.filter (filePath) ->
        if grunt.file.exists filePath
          return true
        else
          grunt.log.warn 'Source file "' + filePath + '" not found.'
          return false;

      if filtered.length is 0
        if fileSet.src.length == 0
          grunt.log.warn 'Destination ' + chalk.cyan(destFile) +
            ' not written because no source files were found.'
        return

      filtered.forEach (filePath) ->
        contents = grunt.file.read filePath
        compiled = Handlebars.compile(contents)(options)
        grunt.file.write destFile, compiled
        count++

    grunt.log.ok "#{count} #{grunt.util.pluralize(count, 'file/files')} created."

  grunt.initConfig
    pkg: grunt.file.readJSON 'package.json'
    clean:
      build:
        src: ['build']
    coffee:
      compile:
        files: fileSet 'source', 'coffee', '.js'
    copy:
      external:
        files: fileSet 'external', 'js'
    handlebars:
      compile:
        options:
          namespace: 'scheduler.templates'
          processName: (path) ->
            path.substring(path.indexOf('/') + 1, path.length - 11)
                .replace /\//g, '.'
        files: {
          'build/templates/templates.js': ['templates/**/*.handlebars']
        }
    less:
      compile:
        files: fileSet 'styles', 'less', '.css'
    schedule:
      compile:
        files: fileSet 'schedules', 'csv', '.csv.js'
    html:
      compile:
        files: [
          expand : true
          cwd    : 'html'
          src    : ['**/*.handlebars']
          dest   : 'build'
          ext    : '.html'
        ]

  grunt.loadNpmTasks 'grunt-contrib-copy'
  grunt.loadNpmTasks 'grunt-contrib-clean'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-handlebars'
  grunt.loadNpmTasks 'grunt-contrib-less'

  grunt.registerTask 'default', [
    'clean'
    'coffee'
    'copy'
    'handlebars'
    'less'
    'schedule'
    'html'
  ]

getHtmlCompileOptions = (grunt) ->
  directories = grunt.file.expand {
    filter : 'isDirectory'
    cwd    : 'build'
  }, '*'
  results = {}
  directories.forEach (dir) ->
    options =
      cwd      : 'build/' + dir
      filter   : 'isFile'
      baseName : true
    results[dir] = grunt.file.expand(options, '**').map (path) -> dir + '/' + path
  return results

CSV =
  compile: (grunt, path, contents) ->
    lastSep = path.lastIndexOf '/'
    baseName = path.substring lastSep + 1
    lastDot = baseName.lastIndexOf '.'
    name = baseName.substring 0, lastDot
    schedule = contents.replace(/'/g, "\\'").replace(/\n/g, '\\n')

    if schedule.length == 0
      return {name, compiled: ''}

    compiled = CSV.template {name, schedule}
    return {name: baseName, compiled}

  template: Handlebars.compile """
      (function() {
        if (window.schedules == null) {
          window.schedules = {};
        }
        window.schedules.{{name}} = '{{{schedule}}}';
      })();
    """
