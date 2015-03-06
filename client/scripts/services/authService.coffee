'use strict'

##
# Convenience functions for client authentication
#
angular.module('community').factory 'AuthService', ($http, $q, $cookies, $window)->
  currentUser = {}
  loggedIn = false

  return {
    loginFacebook: ->
      route = '/api/auth/facebook/'
      $http.get(route)
        .error (err) ->
          console.log "AuthService: ", "Error requesting route " + route, err
        .success (res) ->
          loggedIn = true
          console.log "AuthService: ", "Facebook authentication succeeded."
    
    loginLocal: (user, successCb, errCb) ->
      $http.post('/api/auth/local/', user)
        .success (res) ->
          loggedIn = true
          successCb()
        .error (err) ->
          loggedIn = false
          errCb(err)
    
    isLoggedIn: ->
      return loggedIn

    logout: ->
      route = '/api/auth/logout'
      $http.get(route).success ->
        loggedIn = false
        $window.location.href = '/'

    checkLoggedIn: ->
      route = '/api/auth/loggedin/'      
      $http.get(route)
        .error (err) ->
          console.log "AuthService: ", "Error requesting route " + route, err
          return false
        .success (res) ->
          loggedIn = if res == "true" then true else false
          console.log "AuthService: ", "loggedIn: ", loggedIn
          return loggedIn

    getCurrentUser: (force) ->
      route = '/api/users/me/'

      deferred = $q.defer()

      if !force && Object.keys(currentUser).length != 0
        deferred.resolve(currentUser)
      else
        $http.get(route)
          .error (err) ->
            console.log "AuthService: ", "Error requesting route " + route, err
            deferred.reject(err)
          .success (user) ->
            # console.log "AuthService: ", "Me = ", user
            currentUser = user
            deferred.resolve(currentUser)

      return deferred.promise
  }
