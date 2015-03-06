'use strict'

express = require 'express'
config = require './config/config'

# instanciate app
app = express()
require('./config/express')(app)

# kind of primitive DI, maybe not the best
require('./resources')(app)

# run server
app.listen config.port, config.host, ->
  console.log 'Express server listening on port %d, serving from %s', config.port, config.root

exports = module.exports = app;
