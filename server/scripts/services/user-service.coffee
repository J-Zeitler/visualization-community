'use strict'

auth = require '../middleware/auth'
pbkdf2 = require('../config/config').pbkdf2
crypto = require 'crypto'
md5 = require 'MD5'

##
# User resource. Includes routes and logic for users
#
module.exports = (app) ->
  # Import models
  User = app.get('models').User
  Visualization = app.get('models').Visualization
  UserHistory = app.get('models').UserHistory

  ##
  # Get all users filtered by optional params
  # 
  app.get '/api/users', auth.user, (req, res) ->
    filters = req.query
    User
    .findAll({
      where: {
        username: if filters.username then {like: '%' + filters.username + '%'} else {}
      }
    })
    .error (err) ->
      res.send 500, "DB error: " +  err
    .success (dbResponse) ->
      res.json dbResponse

  ##
  # Get current user
  #
  app.get '/api/users/me', auth.user, (req, res) ->
    meId = req.user.dataValues.id
    User
      .find({
        where: {id: meId}
        include: [Visualization]
      })
      .error (err) ->
        res.send 500, "DB error: " + err
      .success (user) ->
        user.getFollowee({attributes: ['id']})
        .success (followees) ->
          user.dataValues.followees = followees.map (f) -> f.dataValues.id
          res.json user

  ##
  # Get user by id
  #
  app.get '/api/users/:id', auth.user, (req, res) ->
    id = req.params.id
    User
      .find({
        where: {id: id}
        include: [Visualization]
      })
      .error (err) ->
        res.send 500, "DB error: " + err
      .success (dbResponse) ->
        res.json dbResponse

  ##
  # Get visualizations by user id
  #
  app.get '/api/users/:id/visualizations', auth.user, (req, res) ->
    id = req.params.id
    Visualization.findAll({where: {UserId: id}})
    .error (err) ->
      res.send 500, "DB error: " +  err
    .success (dbResponse) ->
      res.json dbResponse

  ##
  # Create new user
  # 
  app.post '/api/users', (req, res) ->
    user = req.body
    User
    .create {
      username: user.username
      password: crypto.pbkdf2Sync(user.password, pbkdf2.salt, pbkdf2.iter, pbkdf2.keylen).toString()
      mailHash: md5 user.email
      email: user.email
    }
    .error (err) ->
      res.send 500, "DB error: " + err
    .success (dbResponse) ->
      # console.log "Created user: ", user
      res.json dbResponse
      UserHistory.create {
        action: 'created'
      }
      .success (history) ->
        history.setUser dbResponse
  
  ##
  # Update user
  #
  app.put '/api/users/:id/edit', auth.user, (req, res) ->
    user = req.body
    
    if req.user.id != user.id
      res.send 403, "Users may only update their own credentials"

    User
    .find(user.id)
    .error (err) ->
      res.send 500, "DB error: " + err
    .success (dbResponse) ->
      if dbResponse
        dbResponse.updateAttributes {
          username: user.username
          password: user.password
          mailHash: md5 user.email
          email: user.email
        }
        .error (err) ->
          res.send 500, "DB error: " + err
        .success (dbResponse) ->
          console.log "Updated user: ", user
          res.json dbResponse
          UserHistory.create {
            action: 'updated'
          }
          .success (history) ->
            history.setUser dbResponse

  ##
  # Follow user
  # 
  app.post '/api/users/:userId/follow', auth.user, (req, res) ->
    id = req.params.userId

    User.find(id)
      .error (err) ->
        res.send 500, "DB error: " +  err
      .success (followee) ->
        User.find(req.user.dataValues.id)
        .error (err) ->
          res.send 500, "DB error: " +  err
        .success (follower) ->
          follower.addFollowee followee
          res.send 200

  ##
  # Unfollow user
  # 
  app.del '/api/users/:userId/follow', auth.user, (req, res) ->
    id = req.params.userId

    User.find(id)
      .error (err) ->
        res.send 500, "DB error: " +  err
      .success (followee) ->
        User.find(req.user.dataValues.id)
        .error (err) ->
          res.send 500, "DB error: " +  err
        .success (follower) ->
          follower.removeFollowee(followee)
          .success (r) ->
            res.send 200