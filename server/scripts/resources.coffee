'use strict'

index = require './static'
fs = require 'fs'

##
# Resource importer
#
module.exports = (app) ->

  # api resources
  services = fs.readdirSync './server/js/services'  
  for service in services
    service = service.slice 0, service.indexOf '.js'
    require('./services/' + service)(app)

  # static files
  app.get '/partials/*', index.partials
  app.get '/*', index.index
