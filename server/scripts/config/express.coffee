'use strict'

express = require 'express'
config = require './config'
path = require 'path'
passport = require 'passport'

##
# Express app config/initialization
#
module.exports = (app) ->

  app.configure ->
    # static files and template rendering
    app.use express.static path.join config.root, 'client'
    app.engine 'html', require('ejs').renderFile
    app.set 'views', config.root + '/client/views'
    app.set 'view engine', 'html'

    # db models setup
    app.set 'models', require('../models')

    # passport setup - some of this might be obsolete
    require('./passport')(app, passport);
    app.use express.cookieParser('secret') # use cookies for sessions
    app.use express.cookieSession {cookie: { maxAge: 60 * 60 * 1000, httpOnly: true }}
    app.use passport.initialize()
    app.use passport.session()

    # request setup
    # app.use express.logger()
    app.use express.json()
    app.use express.methodOverride() # enable delete and put
    app.use express.urlencoded() # enable req.body style http request objects
    app.use app.router

  app.getPassport = ->
    passport