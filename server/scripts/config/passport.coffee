'use strict'

FacebookStrategy = require('passport-facebook').Strategy
LocalStrategy = require('passport-local').Strategy
credentials = require('./config').auth
pbkdf2 = require('./config').pbkdf2
crypto = require 'crypto'

cookieParser = require 'cookie'
md5 = require 'MD5'

##
# Passport object config/initialization
#
module.exports = (app, passport) ->
  # Import user model
  User = app.get('models').User

  passport.serializeUser (user, done) ->
    console.log 'Serializing user'
    done(null, user.id)

  passport.deserializeUser (id, done) ->
    console.log 'Deserializing user'
    User.find(id)
      .error (err) ->
        console.log "Passport: deserializeUser",  err
        done(err, {})
      .success (dbResponse) ->
        done(null, dbResponse)

  passport.use new LocalStrategy {
      usernameField: 'email',
      passwordField: 'password'
    }, (mail, pass, done) ->
    console.log 'Attempting local authentication'
    User
    .find({where: {email: mail}})
    .error (err) ->
      return done(null, false, {message: "DB error."})
    .success (user) ->
      if !!user && user.getDataValue('password') == crypto.pbkdf2Sync(pass, pbkdf2.salt, pbkdf2.iter, pbkdf2.keylen).toString()
        # user.token = crypto.randomBytes(20).toString('hex')
        user.save()
        .error (err) ->
            console.log "Error saving token to DB: ", err
        .success (dbResponse) ->
          done(null, dbResponse)
      else
        done(null, false, {message: "There is no user with that username."})


  passport.use new FacebookStrategy {
    clientID: credentials.facebookAppId
    clientSecret: credentials.facebookAppSecret
    callbackURL: credentials.facebookCallbackURL
  }, (accessToken, refreshToken, profile, done) ->
    console.log 'Running FacebookStrategy callback'
    # console.log profile
    User.find({where: {email: profile._json.email}})
    .error (err) ->
      console.log "DB error", err
      done(null, false, {message: "DB error."})
    .success (user) ->
      if user == null
        User
          .create {
            username: profile._json.name
            email: profile._json.email
            password: ''
            mailHash: md5 profile._json.email
            token: accessToken
          }
          .error (err) ->
            console.log "Failed to create new facebook user: ", err
            done(null, false, {message: "Failed to create new user."})
          .success (dbResponse) ->
            console.log "Created new user: ", dbResponse.email
            done(null, dbResponse)

      else
        user.token = accessToken
        user.save()
          .error (err) ->
            console.log "Error saving token to DB: ", err
            done(null, false, {message: "Error saving token."})
          .success (dbResponse) ->
            console.log "Token saved"
            done(null, dbResponse)
