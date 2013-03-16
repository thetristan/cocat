# Cocat

Node module for asynchronous CSS file concatenation. Looks for @import statements and replaces them with the actual content of the file if it exists, otherwise it just leaves the @import statement as-is.

### Usage

Use it in your scripts by specifying a file

```javascript
Cocat = require('cocat');
Cocat.concat({
  filename: 'path_to_file.css'
}, function(err, output) {
  // ...
});
```

Or by specifying a string and a path to use instead

```javascript
Cocat = require('cocat');
Cocat.concat({
  content: '/* CSS GOES HERE */'
  path:    '../foo/bar/'
}, function(err, output) {
  // ...
});
```

It also works great on the command line:

```
Usage: cocat [options] input.css [output.css]

Options:

  -h, --help     output usage information
  -V, --version  output the version number
  -s, --save     save output to a file based on the inputfile name
```

Examples:

```
$ cocat bar.css          # concats and ouputs to stdout
$ cocat -s foo.css       # concats and saves to foo.concat.css
$ cocat baz.css qux.css  # concats and saves to qux.css
```

Happy concatenating!
