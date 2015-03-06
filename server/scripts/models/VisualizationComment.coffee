'use strict'

module.exports = (sequelize, DataTypes) ->
  sequelize.define 'VisualizationComment', {
    text: {
      type: DataTypes.TEXT
      allowNull: false
    }
  }, {
    instanceMethods: {
      # maybe some complex logic here ...
    }
  }
