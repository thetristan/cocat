async = require 'async'
fs    = require 'fs'
path  = require 'path'
_     = require 'underscore'

{compact, times} = _

pattern = /@import\s(?:url\()?["']([^"';]+?)["']\)?;/i
depth = 0

split = (str) -> str.split("\n")
merge = (arr) -> arr.join("\n")

padding = (levels, padding = '') ->
  times levels, -> padding += '  '
  padding

padContent = (content, levels = depth) ->
  return '' unless content
  lines = split(content)
  lines = lines.map (line) -> padding(levels) + line
  merge(lines)

concatFile = (filename, cb) ->
  filename = path.resolve(filename)
  fs.readFile filename, 'utf8', (err, data) ->
    throw err if err?
    concatString(data, path.dirname(filename), cb)

concatString = (content, filepath, cb) ->
  lines = split(content)
  numLines = lines.length - 1
  lineNumbers = (x for x in [0..numLines])

  checkLine = (lineNumber, next) ->
    matches = lines[lineNumber]?.match(pattern)
    return next() unless matches

    filename = matches[1]
    return next() if filename.match(/^[a-z]+:/i)

    file = filepath + '/' + filename
    concatFile file, (err, contents) ->
      throw err if err?
      depth++
      paddedContents = padContent(contents)
      lines[lineNumber] = "/* BEGIN \"#{filename}\" */\n#{paddedContents}\n/* END \"#{filename}\" */"
      depth--
      next()

  async.forEach lineNumbers, checkLine, (err) ->
    lines = lines.map (line) -> line.replace(/\s+$/,'')
    lines = compact(lines)
    content = merge(lines)
    cb(null, content)

concat = ({content, path, filename}, cb) ->
  return concatString(content, path, cb) if content && path
  return concatFile(filename, cb) if filename

  throw "Content/path or a filename must be specified to concatenate"

module.exports.concat = concat
