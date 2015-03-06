'use strict'

##
# Authentication resource. Includes routes and logic for authentication
#
module.exports = (app) ->
  # Import User model
  User = app.get('models').User
  passport = app.getPassport()

  app.post '/api/auth/local', passport.authenticate('local'), (req, res) ->
    console.log "auth-service: ", "Local authentication successfull"
    res.json 200

  app.get '/api/auth/facebook', passport.authenticate('facebook', {
      scope: ['email']
      profileFields: ['email']
    }), (req, res) ->
    console.log "auth-service: ", "Attempting to authenticate with facebook"
    res.send 200

  app.get '/api/auth/facebook/callback/',
    passport.authenticate('facebook', {
      failureRedirect: '/login/'
    }), (req, res) ->
      console.log "auth-service: ", "Facebook authentication successfull"
      res.redirect '/'

  app.get '/api/auth/loggedin', (req, res) ->
    res.json req.isAuthenticated()

  app.get '/api/auth/logout', (req, res) ->
    req.session = null
    # console.log req.session
    # req.session.destroy()
    res.send 200
