'use strict'

module.exports = (sequelize, DataTypes) ->
	sequelize.define 'UserHistory', {
		action: {
			type: DataTypes.STRING,
			validate: {
				is: ["updated|created|deleted|subscribed|unsubscribed"]
			}
		}
	}, {
		instanceMethods: {
			# maybe some complex logic here ...
		}
		createdAt: false
	}
