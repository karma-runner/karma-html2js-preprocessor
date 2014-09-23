var util = require('util');


var TEMPLATE = '' +
  'window.__html__ = window.__html__ || {};\n' +
  'window.__html__[\'%s\'] = \'%s\'';

var escapeContent = function(content) {
  return content.replace(/\\/g, '\\\\').replace(/'/g, '\\\'').replace(/\r?\n/g, '\\n\' +\n    \'');
};

var createHtml2JsPreprocessor = function(logger, basePath, config) {
  config = typeof config === 'object' ? config : {};

  var log = logger.create('preprocessor.html2js');
  var stripPrefix = config.stripPrefix ? new RegExp('^' + config.stripPrefix) : null;
  var prependPrefix = config.prependPrefix ? config.prependPrefix : '';
  var processPath = config.processPath || function(htmlPath) {
    htmlPath = prependPrefix + htmlPath.replace(stripPrefix, '');
    return htmlPath;
  };

  return function(content, file, done) {
    log.debug('Processing "%s".', file.originalPath);

    var htmlPath = processPath(file.originalPath.replace(basePath + '/', ''));

    file.path = file.path + '.js';
    done(util.format(TEMPLATE, htmlPath, escapeContent(content)));
  };
};

createHtml2JsPreprocessor.$inject = ['logger', 'config.basePath', 'config.html2JsPreprocessor'];

module.exports = createHtml2JsPreprocessor;
