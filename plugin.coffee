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

  EjsTemplate.fromFile = (filepath, callback) ->  
    fs.readFile filepath.full, (error, contents) ->
      if error then callback error
      else
        try
          tpl = ejs.compile contents.toString(), { filename: filepath.full }
          callback null, new EjsTemplate tpl
        catch error
          callback error

  wintersmith.registerTemplatePlugin '**/*.ejs', EjsTemplate
  callback()
