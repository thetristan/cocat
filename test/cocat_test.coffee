{equal} = expect = require('assert')
{concat} = require('../lib/cocat')

describe 'Cocat module', ->
  it 'should import and concatenate files using @import "foo.css"; syntax', (done) ->

    concat filename: "#{__dirname}/fixtures/test.css", (err, result) ->
      expected = """
        /* BEGIN "imported.css" */
          h2 { font-size: 36px; }
        /* END "imported.css" */
        /* BEGIN "sub/imported_also.css" */
          h3 { font-size: 24px; }
          /* BEGIN "../child_import.css" */
            h4 { font-size: 16px; }
          /* END "../child_import.css" */
        /* END "sub/imported_also.css" */
        h1 { font-size: 48px; }
        """

      equal(err, null)
      equal(result, expected)
      done()

  it 'should import and concatenate files using @import url("foo.css"); syntax', (done) ->
    concat filename: "#{__dirname}/fixtures/test-url.css", (err, result) ->

      expected = """
        /* BEGIN "imported.css" */
          h2 { font-size: 36px; }
        /* END "imported.css" */
        /* BEGIN "sub/imported_also.css" */
          h3 { font-size: 24px; }
          /* BEGIN "../child_import.css" */
            h4 { font-size: 16px; }
          /* END "../child_import.css" */
        /* END "sub/imported_also.css" */
        h1 { font-size: 48px; }
        """

      equal(err, null)
      equal(result, expected)
      done()

  it 'should skip data uris and http-based @imports', (done) ->
    concat filename: "#{__dirname}/fixtures/test-url-bad.css", (err, result) ->

      expected = """
        @import url("http://www.google.com/foo.css");
        @import url("data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABAAAAAQAQMAAAAlPW0iAAAABlBMVEUAAAD///+l2Z/dAAAAM0lEQVR4nGP4/5/h/1+G/58ZDrAz3D/McH8yw83NDDeNGe4Ug9C9zwz3gVLMDA/A6P9/AFGGFyjOXZtQAAAAAElFTkSuQmCC");
        h1 { font-size: 48px; }
        """

      equal(err, null)
      equal(result, expected)
      done()
