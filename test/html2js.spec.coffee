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

  beforeEach ->
    process = html2js logger, '/base'


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

  it 'should preserve backslashes in html', (done) ->
    file = new File '/base/path/file.html'

    process 'first\\second', file, (processedContent) ->
      expect(processedContent).to.contain 'first\\second'
      done()


  it 'should escape backslashes in json', (done) ->
    file = new File '/base/path/file.json'

    process '{"test":"first\\r\\nsecond\'third\'"\r\n"test2":123}', file, (processedContent) ->
      expect(processedContent).to.contain '{"test":"first\\\\r\\\\nsecond\\\'third\\\'"\\n\' +\n    \'"test2":123}'
      done()
