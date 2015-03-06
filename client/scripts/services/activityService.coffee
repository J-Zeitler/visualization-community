'use strict'

##
# Service for communication with the backend activity API.
#
angular.module('community').factory 'ActivityService', ($http) ->

  return {
    findById: (id, done) ->
      route = '/api/activities/' + id

      if typeof done != 'function'
        throw "ActivityService findById need a callback function as argument"

      $http.get(route)
      .error (err) ->
        console.error "ActivityService: ", "Error requesting route " + route, err
        done(false)
      .success (activity) ->
        if Object.keys(activity).length == 0
          console.error "ActivityService: ", "no activity with id " + id + " found"
          done(false)
        else
          console.log "ActivityService: ", "found activity: ", activity
          done(activity)

    findAll: (done) ->
      route = '/api/activities/'

      if typeof done != 'function'
        throw "ActivityService findAll need a callback function as argument"

      $http.get(route)
      .error (err) ->
        console.error "ActivityService: ", "Error requesting route " + route, err
        done(false)
      .success (activities) ->
        console.log "ActivityService: ", "found activities: ", activities
        done(activities)

    findByUserId: (userId, done) ->      
      route = '/api/activities/' + userId

      if typeof done != 'function'
        throw "ActivityService findAll need a callback function as argument"

      $http.get(route)
      .error (err) ->
        console.error "ActivityService: ", "Error requesting route " + route, err
        done(false)
      .success (activities) ->
        console.log "ActivityService: ", "found activities: ", activities
        done(activities)

    findFiltered: (opts, done) ->
      route = '/api/activities/'

      if typeof done != 'function'
        throw "ActivityService findFiltered need a callback function as argument"

      $http.post(route, opts, {cache: off})
      .error (err) ->
        console.error "ActivityService: ", "Error requesting route " + route, err
        done(false)
      .success (activities) ->
        console.log "ActivityService: ", "found activities: ", activities
        done(activities)
  }