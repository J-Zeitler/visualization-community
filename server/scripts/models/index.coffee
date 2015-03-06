'use strict'

Sequelize = require 'sequelize'
config = require '../config/config'

sequelize = new Sequelize(
  config.db.name,
  config.db.user,
  config.db.pass,
  config.db.options
)

# import models
models = [
  'User',
  'Visualization'
  'UserHistory'
  'VisualizationHistory'
  'VisualizationComment'
]

models.forEach (model) ->
  module.exports[model] = sequelize.import __dirname + '/' + model


# relations
((m) ->
  # Followers
  m.User.hasMany(m.User, {as: 'Followee', through: 'user_follows'})

  # Visualization relations
  m.User.hasMany(m.Visualization)
  m.Visualization.belongsTo(m.User, {as: 'Creator'})

  m.Visualization.hasMany(m.User, {as: 'Starrer', through: 'visualization_stars'})
  m.User.hasMany(m.Visualization, {through: 'visualization_stars'})

  # VisualizationComment relations
  m.Visualization.hasMany(m.VisualizationComment, as: 'Comments')
  m.VisualizationComment.belongsTo(m.User, as: 'Commenter')

  # History relations
  m.User.hasMany(m.UserHistory)
  m.UserHistory.belongsTo(m.User)
  
  m.Visualization.hasMany(m.VisualizationHistory)
  m.User.hasMany(m.VisualizationHistory)
  m.VisualizationHistory.belongsTo(m.Visualization)
  m.VisualizationHistory.belongsTo(m.User)
)(module.exports)

# Create tables
sequelize
  .authenticate()
  .complete (err) ->
    if !!err
      console.log 'Unable to connect to the database:', err
    else
      console.log 'Connection has been established successfully.'

_force = no
sequelize
  .sync({force: _force})
  .complete (err) ->
    if !!err
      console.log 'An error occurred while creating the table:', err
    else
      console.log 'Database syncronized'

      if _force
        # Mocks
        User = module.exports.User
        Visualization = module.exports.Visualization
        UserHistory = module.exports.UserHistory
        VisualizationHistory = module.exports.VisualizationHistory

        User.create {
          username: 'Mock User'
          password: 'pass'
          email: 'mock@community.com'
        }
        .success (user) ->
          UserHistory.create {
            action: 'created'
          }
          .success (history) ->
            history.setUser user
          Visualization.create {
            title: 'Mock Visualization'
            type: 'mock'
            description: 'Lorem ipsum dolor sit amet, consectetur adipisicing elit. Quasi, hic iusto doloremque repellendus optio animi id dolore distinctio a minus nam iure officiis voluptatibus deleniti blanditiis nihil at autem dicta.'
          }
          .success (visualization) ->
            VisualizationHistory.create {
              action: 'created'
            }
            .success (history) ->
              history.setVisualization visualization
              history.setUser user
            visualization.setCreator user
            .success ->
              Visualization.findAll {
                include: [{
                  model: User
                  as: 'Creator'
              }]}
              .success (v) ->
                # console.log v[0].values

# db connection
module.exports.sequelize = sequelize
