ejs = require 'ejs'
path = require 'path'
fs = require 'fs'

module.exports = (wintersmith, callback) ->

  class EjsTemplate extends wintersmith.TemplatePlugin

    constructor: (@tpl) ->

    render: (locals, callback) ->
      try
        callback null, new Buffer @tpl(locals)
      catch error
        callback error

  EjsTemplate.fromFile = (filename, base, callback) ->  
    fs.readFile path.join(base, filename), (error, contents) ->
      if error then callback error
      else
        try
          tpl = ejs.compile contents.toString(), { filename: filename }
          callback null, new EjsTemplate tpl
        catch error
          callback error

  wintersmith.registerTemplatePlugin '**/*.ejs', EjsTemplate
  callback()