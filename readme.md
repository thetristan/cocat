# Cocat

Node module for asynchronous CSS file concatenation. Looks for @import statements and replaces them with the actual content of the file if it exists, otherwise it just leaves the @import statement as-is.

### Usage

Use it in your scripts by specifying a file

    Cocat = require('cocat');
    Cocat.concat({
      filename: 'path_to_file.css'
    }, (err, output) {
      ...
    });

Or by specifying a string and a path to use instead

    Cocat = require('cocat');
    Cocat.concat({
      content: '/* CSS GOES HERE */'
      path:    '../foo/bar/'
    }, (err, output) {
      ...
    });


It also works great on the command line:

    $ cocat [-hc] input.css [output.css]

Available options:

      -h, --help
        Show this help information.

      -c, --compile
        Compile the file, even if no output file is specified.
        E.g `cocat -c style.css` will save output to style.concat.css

Happy concatenating!
