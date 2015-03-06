'use strict'

auth = require '../middleware/auth'

##
# Activity resource. Includes routes and logic for feed activities
#
module.exports = (app) ->
  # Import models
  User = app.get('models').User
  Visualization = app.get('models').Visualization
  UserHistory = app.get('models').UserHistory
  VisualizationHistory = app.get('models').VisualizationHistory

  ##
  # Get 10 latest changes with eager loading for all relations
  #
  app.get '/api/activities', auth.user, (req, res) ->
    VisualizationHistory.findAll {
      limit: 10
      include: [{
        model: Visualization
        include: [{
          model: User
          as: 'Creator'
        }]
      }]
    }
    .error (err) ->
      res.send 500, "DB error: " +  err
    .success (vHist) ->
      UserHistory.findAll {
        limit: 10
        include: [User]
      }
      .error (err) ->
        res.send 500, "DB error: " +  err
      .success (uHist) ->
        allHist = vHist.concat uHist
        allHist.sort (a, b) ->
          da = new Date(a.updatedAt)
          db = new Date(b.updatedAt)
          return db-da
        res.json allHist


  ##
  # Get 10 latest activities by user
  #
  app.get '/api/activities/:userId', auth.user, (req, res) ->
    id = req.params.userId
    VisualizationHistory.findAll {
      where: {UserId: id}
      limit: 10
      include: [{
        model: Visualization
        include: [{
          model: User
          as: 'Creator'
        }]
      }]
    }
    .error (err) ->
      res.send 500, "DB error: " +  err
    .success (vHist) ->
      UserHistory.findAll {
        where: {UserId: id}
        limit: 10
        include: [User]
      }
      .error (err) ->
        res.send 500, "DB error: " +  err
      .success (uHist) ->
        allHist = uHist.concat vHist
        allHist.sort (a, b) ->
          da = new Date(a.updatedAt)
          db = new Date(b.updatedAt)
          return db-da
        res.json allHist

  ##
  # Get 10 filtered by object with (optional) attrs:
  # @userIds
  # @visualizationIds
  #
  app.post '/api/activities/', auth.user, (req, res) ->
    filters = req.body
    console.log filters

    VisualizationHistory.findAll {
      limit: 10
      include: [{
        model: Visualization
        include: [{
          model: User
          as: 'Creator'
        }]
      }]
      where: {
        UserId: filters.userIds || {}
        VisualizationId: filters.visualizationIds || {}
      }
    }
    .error (err) ->
      res.send 500, "DB error: " +  err
    .success (vHist) ->
      UserHistory.findAll {
        limit: 10
        include: [User]
        where: {
          UserId: filters.userIds || {}
        }
      }
      .error (err) ->
        res.send 500, "DB error: " +  err
      .success (uHist) ->
        allHist = vHist.concat uHist
        allHist.sort (a, b) ->
          da = new Date(a.updatedAt)
          db = new Date(b.updatedAt)
          return db-da
        res.json allHist
