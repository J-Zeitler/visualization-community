'use strict'

##
# Middleware for validating logged in users
#
module.exports.user = (req, res, next) ->
  if !req.isAuthenticated()
    res.send 401
  else
    next()