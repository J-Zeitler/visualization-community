'use strict'

##
# Service for communication with the backend users API.
#
angular.module('community').factory 'UserService', ($http, $q, md5)->
  userMap = {}

  return {
    findById: (id, done) ->
      route = '/api/users/' + id

      if typeof done != 'function'
        throw "UserService findById need a callback function as argument"

      $http.get(route)
      .error (err) ->
        console.error "UserService: ", "Error requesting route " + route, err
        done(false)
      .success (user) ->
        if user == "null"
          console.error "UserService: ", "no user with id " + id + " found"
          done(false)
        else
          console.log "UserService: ", "found user: ", user
          user.mailHash = md5.createHash(user.email)
          vMap = {}
          user.visualizations.map (v) ->
            vMap[v.id] = v
          user.visualizations = vMap
          done(user)

    findAll: (done) ->
      route = '/api/users/'

      if typeof done != 'function'
        throw "UserService: findAll needs a callback function as argument"

      $http.get(route)
      .error (err) ->
        console.error "UserService: ", "Error requesting route " + route, err
        done(false)
      .success (users) ->
        userMap = {}
        users.map (user) ->
          userMap[user.id] = user
        console.log "UserService: ", "found users: ", userMap
        done(userMap)

    findFiltered: (filters, done) ->
      route = '/api/users?'
      for filter, query of filters
        route += filter + '=' + query

      if typeof done != 'function'
        throw "UserService: findAll needs a callback function as argument"

      $http.get(route)
      .error (err) ->
        console.error "UserService: ", "Error requesting route " + route, err
        done(false)
      .success (users) ->
        userMap = {}
        users.map (user) ->
          userMap[user.id] = user
        console.log "UserService: ", "found users: ", userMap
        done(userMap)

    update: (u, done) ->
      route = '/api/users/' + u.id + '/edit/'

      if typeof done != 'function'
        throw "UserService: update need a callback function as argument"

      $http.put(route, u)
      .error (err) ->
        console.error "UserService: ", "Error requesting route " + route, err
        done(false)
      .success (user) ->
        console.log "UserService: ", "updated user: ", user
        done(user)

    # TODO: This may not belong here
    findVisualizations: (id, done) ->
      route = '/api/users/' + id + '/visualizations/'

      if typeof done != 'function'
        throw "UserService: findVisualizations needs a callback function as argument"

      $http.get(route)
      .error (err) ->
        console.error "UserService: ", "Error requesting route " + route, err
        done(false)
      .success (visualizations) ->
        console.log "UserService: ", "found visualizations: ", visualizations
        done(visualizations)

    followUser: (id, done) ->
      route = '/api/users/' + id + '/follow'

      if typeof done != 'function'
        throw "UserService: findVisualizations needs a callback function as argument"

      $http.post(route)
      .error (err) ->
        console.error "UserService: ", "Error requesting route " + route, err
        done(false)
      .success (res) ->
        console.log "UserService: ", "follow user OK"
        done(res)

    unfollowUser: (id, done) ->
      route = '/api/users/' + id + '/follow'

      if typeof done != 'function'
        throw "UserService: findVisualizations needs a callback function as argument"

      $http.delete(route)
      .error (err) ->
        console.error "UserService: ", "Error requesting route " + route, err
        done(false)
      .success (res) ->
        console.log "UserService: ", "unfollow user OK"
        done(res)
  }
