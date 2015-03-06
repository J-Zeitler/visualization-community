'use strict'

auth = require '../middleware/auth'

##
# Visualization resource. Includes routes and logic for visualizations
#
module.exports = (app) ->
  # Import models
  Visualization = app.get('models').Visualization
  User = app.get('models').User
  VisualizationHistory = app.get('models').VisualizationHistory
  VisualizationComment = app.get('models').VisualizationComment

  ##
  # Get all visualizations filtered by optional params
  #
  app.get '/api/visualizations', auth.user, (req, res) ->
    filters = req.query

    # TODO: this should not be necessary
    customWhere = ""
    keys = Object.keys(filters)
    for k, i in keys
      customWhere += k + " LIKE '%" + filters[k] + "%'"
      if i < (keys.length - 1) then customWhere += " OR "

    Visualization.findAll({
      include: [{
        model: User
        as: 'Creator'
      }, {
        model: User
        as: 'Starrer'
        attributes: ['id']
      }],
      where: [
        customWhere
      ]
    })
    .error (err) ->
      res.send 500, "DB error: " +  err
    .success (visualizations) ->
      # TODO: maybe not use sequelize next time ...
      visualizations.forEach (v) ->
        v.dataValues.starredBy = v.dataValues.starrer.map (s) -> s.dataValues.id
        delete v.dataValues.starrer
      res.json visualizations

  ##
  # Get visualization by id
  #
  app.get '/api/visualizations/:id', (req, res) ->
    id = req.params.id
    Visualization.find({
      where: {id: id}
      include: [{
        model: User
        as: 'Creator'
      },{
        model: VisualizationComment
        include: [{
          model: User
          as: 'Commenter'  
        }]
        as: 'Comments'
    }]})
    .error (err) ->
      res.send 500, "DB error: " +  err
    .success (v) ->
      v.getStarrer({attributes: ['id']})
      .success (starrers) ->
        v.dataValues.starredBy = starrers.map (s) -> s.dataValues.id
        res.json v

  ##
  # Update visualization
  #
  app.put '/api/visualizations/:id/edit', auth.user, (req, res) ->
    v = req.body
    if req.user.id != v.UserId
      res.send 403, "Only this visualization's owner can make changes to it"

    Visualization.find(v.id)
    .error (err) ->
      res.send 500, "DB error: " + err
    .success (visualization) ->
      if !!v.title
        visualization.title = v.title
      if !!v.type
        visualization.type = v.type
      if !!v.description
        visualization.description = v.description

      visualization.save()
      .error (err) ->
        res.send 500, "Error saving record to DB"
      .success (dbResponse) ->
        res.json dbResponse
        VisualizationHistory.create {
          action: 'updated'
        }
        .success (history) ->
          User.find(req.user.id)
          .success (user) ->
            history.setVisualization dbResponse
            history.setUser user
  ##
  # Create visualization
  #
  app.post '/api/visualizations', auth.user, (req, res) ->
    v = req.body

    User.find(req.user.id)
    .error (err) ->
      res.send 500, "DB error: " + err
    .success (creator) ->
      Visualization.create {
        title: v.title
        type: v.type
        description: v.description
      }
      .error (err) ->
        res.send 500, "DB error: " + err
      .success (visualization) ->
        # TODO: check if this is an issue (creating entry for both 'star' and 'creator')
        # creator.addVisualization(visualization)
        visualization.setCreator creator
        .success (dbResponse) ->
          # console.log "Created new visualization: ", dbResponse
          res.json dbResponse
          VisualizationHistory.create {
            action: 'created'
          }
          .success (history) ->
            history.setVisualization dbResponse
            history.setUser creator

  ##
  # Delete visualization
  #
  app.del '/api/visualizations/:id', auth.user, (req, res) ->
    id = req.params.id
    Visualization.find(id)
    .error (err) ->
      res.send 500, "DB error: " + err
    .success (v) ->
      if req.user.id != v.UserId
        res.send 403, "Only this visualization's owner can make changes to it"
      else
        v.setStarrer []
        v.destroy()
        .success ->
          VisualizationHistory.destroy("`VisualizationId` = " + id)
          res.send 200

  ##
  # Add star to visualization
  #
  app.post '/api/visualizations/:id/star', auth.user, (req, res) ->
    id = req.params.id
    Visualization.find(id)
    .error (err) ->
      res.send err.status, "DB error: " + err
    .success (v) ->
      User.find(req.user.id)
      .error (err) ->
        res.send err.status, "DB error: " + err
      .success (u) ->
        v.addStarrer(u)
        .success (v) ->
          res.json v

  ##
  # Remove star from visualization
  #
  app.delete '/api/visualizations/:id/star', auth.user, (req, res) ->
    id = req.params.id
    Visualization.find(id)
    .error (err) ->
      res.send err.status, "DB error: " + err
    .success (v) ->
      User.find(req.user.id)
      .error (err) ->
        res.send err.status, "DB error: " + err
      .success (u) ->
        v.removeStarrer(u)
        .success (v) ->
          res.json v

  ##
  # Add comment to visualization
  #
  app.post '/api/visualizations/:id/comment', auth.user, (req, res) ->
    id = req.params.id
    comment = req.body
    console.log req.body
    Visualization.find(id)
    .error (err) ->
      res.send err.status, "DB error: " + err
    .success (v) ->
      User.find(req.user.id)
      .error (err) ->
        res.send err.status, "DB error: " + err
      .success (u) ->
        VisualizationComment.create {
          text: comment.text
        }
        .error (err) ->
          res.send err.status, "DB error: " + err
        .success (c) ->
          v.addComment c
          .success ->
            c.setCommenter u
            .success (dbResponse)->
              dbResponse.dataValues['commenter'] = u.dataValues
              res.json dbResponse

  ##
  # Remove comment from visualization
  # TODO: is this restful? vId from the url will be redundant
  #
  app.delete '/api/visualizations/:vId/comment/:cId', auth.user, (req, res) ->
    id = req.params.cId
    VisualizationComment.find(id)
    .error (err) ->
      res.send err.status, "DB error: " + err
    .success (c) ->
      c.destroy()
      res.send 200
