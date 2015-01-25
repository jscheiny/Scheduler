fs = require 'fs'
handlebars = require './handlebars-v2.0.0.js'
args = process.argv.slice(2)

isCommand = (arg) -> arg.lastIndexOf("--", 0) == 0
isBuildPath = (path) -> path.lastIndexOf('build/', 0) == 0

extractSet = (args, index, results) ->
  command = args[index].substring(2)
  unless isCommand args[index]
    throw "Unexpected argument: " + args[index]
  index++
  set = []
  while index < args.length and not isCommand args[index]
    set.push(args[index])
    index++
  results[command] = set
  return index

sanitizePaths = (paths) ->
  return [] unless paths?
  for path in paths
    throw ("Disallowed file path: " + path) unless isBuildPath path
    path.substring 6

sanitizeResults = (results, field) ->
  results[field] = sanitizePaths results[field]

parse = (args) ->
  results = {}
  index = 0
  while index < args.length
    index = extractSet args, index, results
  if results.html is undefined
    throw "No html files specified to build."
  sanitizeResults results, 'stylesheets'
  sanitizeResults results, 'externals'
  sanitizeResults results, 'schedules'
  sanitizeResults results, 'sources'
  results.sources.sort (a, b) ->
    return -1 if a == "Templates.js"
    return 1 if b == "Templates.js"
    return -1 if a < b
    return 1 if a > b
    return 0
  return results

buildHtmlPath = (path) ->
  name = path.substring(path.lastIndexOf('/') + 1, path.length - 11)
  return "build/#{name}.html"

handle = (path, info) ->
  fs.readFile path, 'utf-8', (err, text) ->
    throw err if err
    template = handlebars.compile(text)
    outPath = buildHtmlPath path
    fs.writeFile outPath, template(info), (err) ->
      throw err if err
      console.log 'HTML Written: ' + outPath

parsed = parse args
for file in parsed.html
  handle file, parsed
