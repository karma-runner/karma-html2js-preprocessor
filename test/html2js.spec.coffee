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

  beforeEach ->
    process = html2js logger, '/base'


  it 'should change path to *.js', (done) ->
    file = new File '/base/path/file.html'

    process '', file, (processedContent) ->
      expect(file.path).to.equal '/base/path/file.html.js'
      done()

  it 'removes NewLine characters', (done) ->
    file = new File '/base/path/file.html'

    process '<a></a>\r\n<b></b>', file, (processedContent) ->
      expect(processedContent.indexOf('<a></a><b></b>')).not.to.equal(-1)
      done()
