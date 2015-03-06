'use strict'

module.exports = (sequelize, DataTypes) ->
  sequelize.define 'VisualizationHistory', {
    action: {
      type: DataTypes.STRING,
      validate: {
        is: ["updated|created|deleted"]
      }
    }
  }, {
    instanceMethods: {
      # maybe some complex logic here ...
    },
    createdAt: false
  }