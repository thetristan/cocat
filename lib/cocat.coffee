async = require 'async'
fs    = require 'fs'
path  = require 'path'

pattern = /@import\s(?:url\()?["']([^"';]+?)["']\)?;/i
depth = 0

pad = (levels)->
  ('  ' for x in [1..levels]).join('')

pad_content = (content, levels = depth)->
  if content
    lines = (pad(levels)+x for x in content.split("\n"))
    return lines.join "\n"
  ''


concat_file = (filename, callback)->
  filename = path.resolve filename
  path.exists filename, (exists)->
    if exists
      fs.readFile filename, 'utf8', (err, data)->
        concat_string data, path.dirname(filename), (err, content) ->
          callback err, content
    else
      callback new Error "File #{filename} doesn't exist"


concat_string = (content, filepath, callback)->
  lines = content.split "\n"
  line_numbers = (x for x in [0..lines.length-1])

  check_line = (line_number, next)->

    # Get all matches.
    matches = lines[line_number]?.match pattern

    # No matches? Onward.
    return next() unless matches

    filename = matches[1]

    # Ignore data URIs and protocol-based imports
    return next() unless !filename.match(/^data:/i) && !filename.match(/^[a-zA-Z]+:\/\//)

    # Load the file and concatenate that
    concat_file filepath + '/' + filename, (err, contents)->
      depth++;
      lines[line_number] = \
        """
        /* BEGIN \"#{filename}\" */
        #{pad_content contents}
        /* END \"#{filename}\" */
        """
      depth--;
      next()


  async.forEach line_numbers, check_line, (err)->

    # Nuke empty lines
    lines.forEach (line, index)->
      if line.match /^\s*$/
        lines = lines.slice(0, index).concat lines.slice(index+1)

    callback null, lines.join "\n"

concat = (args, callback)->

  if args.content && args.path
    concat_string args.content, args.path, callback
  else if args.filename
    concat_file args.filename, callback
  else
    callback new Error "Content and path or a filename must be specified to concatenate"

module.exports.concat = concat
