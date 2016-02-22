var util = require('util');


var TEMPLATE = '' +
  'window.__html__ = window.__html__ || {};\n' +
  'window.__html__[\'%s\'] = \'%s\'';

var escapeContent = function(content, type) {
  var escaped = content;
  if(type === 'json'){
    escaped = escaped.replace(/\\/g, '\\\\');
  }
  escaped = escaped.replace(/'/g, '\\\'').replace(/\r?\n/g, '\\n\' +\n    \'');
  return escaped;
};

var createHtml2JsPreprocessor = function(logger, basePath) {
  var log = logger.create('preprocessor.html2js');

  return function(content, file, done) {
    log.debug('Processing "%s".', file.originalPath);

    var htmlPath = file.originalPath.replace(basePath + '/', '');
    var extention = file.path.split('.');
    extention = extention.pop();

    file.path = file.path + '.js';
    done(util.format(TEMPLATE, htmlPath, escapeContent(content, extention)));
  };
};

createHtml2JsPreprocessor.$inject = ['logger', 'config.basePath'];

module.exports = createHtml2JsPreprocessor;
