'use strict'

module.exports = (sequelize, DataTypes) ->
  sequelize.define 'Visualization', {
    title: DataTypes.STRING
    type: DataTypes.STRING
    description: DataTypes.TEXT
  }, {
    instanceMethods: {

    }  
  }