'use strict'

path = require 'path'

module.exports = {
  host: '0.0.0.0'
  root: path.normalize(__dirname + '/../../..');
  port: 3000
}

module.exports.db = {
  name: 'sequelize-test'
  user: 'sequelize-test'
  pass: 'pass'
  options: {
    dialect: 'mysql'
    port: 3306
    logging: false
  }
}

module.exports.auth = {
  facebookAppId: '1419784588273426'
  facebookAppSecret: '0f227f10e42fc99733cc49d17c580512'
  facebookCallbackURL: 'http://localhost:3000/api/auth/facebook/callback/'
}

# TODO: is this bad practice?
module.exports.pbkdf2 = {
  salt: 'h0La'
  iter: 1337
  keylen: 64
}
