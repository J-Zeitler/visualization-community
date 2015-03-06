'use strict'

path = require 'path'

##
# Routes for static files
#
exports.partials = (req, res) ->
  stripped = req.url.split('.')[0]
  view = path.join('./', stripped)
  res.render view, (err, html) ->
    if err
      console.error "Error rendering partial '#{view}'\n", err
      res.status 404
      res.send 404
    else
      res.send html

exports.index = (req, res) ->
  res.render 'index'