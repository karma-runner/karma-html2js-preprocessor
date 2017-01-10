describe 'preprocessors html2js', ->
  expect = require('chai').expect;

  html2js = require '../lib/html2js'
  logger = create: -> {debug: ->}
  process = null

  # TODO(vojta): refactor this somehow ;-) it's copy pasted from lib/file-list.js
  File = (path, mtime) ->
    @path = path
    @originalPath = path
    @contentPath = path
    @mtime = mtime
    @isUrl = false

  removeSpacesFrom = (str) ->
    str.replace /[\s\n]/g, ''

  createPreprocessor = (config = {}) ->
    html2js logger, '/base', config

  beforeEach ->
    process = createPreprocessor()

  it 'should change path to *.js', (done) ->
    file = new File '/base/path/file.html'

    process '', file, (processedContent) ->
      expect(file.path).to.equal '/base/path/file.html.js'
      done()

  it 'should preserve new lines', (done) ->
    file = new File '/base/path/file.html'

    process 'first\nsecond', file, (processedContent) ->
      expect(removeSpacesFrom processedContent).to.contain "'first\\n'+'second'"
      done()

  it 'should preserve Windows new lines', (done) ->
    file = new File '/base/path/file.html'

    process 'first\r\nsecond', file, (processedContent) ->
      expect(processedContent).to.not.contain '\r'
      done()

  describe 'options', ->
    it 'strips the given prefix from the file path', (done) ->
      file = new File '/base/path/file.html'

      process = createPreprocessor stripPrefix: 'path/'

      process 'first\r\nsecond', file, (processedContent) ->
        expect(processedContent)
          .to.contain("JST['file.html']").and
          .to.not.contain('path/')
        done()

    it 'prepends the given prefix from the file path', (done) ->
      file = new File '/base/path/file.html'

      process = createPreprocessor prependPrefix: 'served/'

      process 'first\r\nsecond', file, (processedContent) ->
        expect(processedContent)
          .to.contain("JST['served/path/file.html']")
        done()

    it 'invokes custom transform function', (done) ->
      file = new File '/base/path/file.html'
      HTML = '<html></html>'

      process = createPreprocessor
        processPath: (filePath) -> "firstPath/#{filePath}"

      process HTML, file, (processedContent) ->
        expect(processedContent)
          .to.contain("JST['firstPath/path/file.html']")
        done()
