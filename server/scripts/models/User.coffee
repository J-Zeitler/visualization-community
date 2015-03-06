'use strict'

module.exports = (sequelize, DataTypes) ->
  sequelize.define 'User', {
    username: DataTypes.STRING
    password: {
      type: DataTypes.STRING
      # do not serialize
      get: -> return true
    }
    email: DataTypes.STRING
    token: DataTypes.STRING
    mailHash: DataTypes.STRING
  }, {
    instanceMethods: {
      verifyToken: (token) ->
        if this.token == token
          return true
        else
          return false
    }  
  }