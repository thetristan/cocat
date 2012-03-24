cc = require '../lib/cocat'

describe 'Cocat module', ->

  it 'should import and concatenate files using @import "foo.css"; syntax', ->

    complete = false
    result = null

    runs ->
      cc.concat filename: "#{__dirname}/samples/test.css", (err,data)->
        result = data
        complete = true

    waitsFor ->
        complete
      , "...callback never fired", 500

    runs ->
      expected = \
        """
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

      expect(result).toEqual expected

  it 'should import and concatenate files using @import url("foo.css"); syntax', ->

    complete = false
    result = null

    runs ->
      cc.concat filename: "#{__dirname}/samples/test-url.css", (err,data)->
        result = data
        complete = true

    waitsFor ->
        complete
      , "...callback never fired", 500

    runs ->
      expected = \
        """
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
      expect(result).toEqual expected



  it 'should skip data uris and http-based @imports', ->

    complete = false
    result = null

    runs ->
      cc.concat filename: "#{__dirname}/samples/test-url-bad.css", (err,data)->
        result = data
        complete = true

    waitsFor ->
        complete
      , "...callback never fired", 500

    runs ->
      expected = \
        """
        @import url("http://www.google.com/foo.css");
        @import url("data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABAAAAAQAQMAAAAlPW0iAAAABlBMVEUAAAD///+l2Z/dAAAAM0lEQVR4nGP4/5/h/1+G/58ZDrAz3D/McH8yw83NDDeNGe4Ug9C9zwz3gVLMDA/A6P9/AFGGFyjOXZtQAAAAAElFTkSuQmCC");
        h1 { font-size: 48px; }
        """

      expect(result).toEqual expected


