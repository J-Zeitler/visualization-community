'use strict'

##
# Service for communication with the backend visualizations API.
#
angular.module('community').factory 'VisualizationService', ($http)->

  return {
    findById: (id, done) ->
      route = '/api/visualizations/' + id

      if typeof done != 'function'
        throw "VisualizationService findById need a callback function as argument"

      $http.get(route)
      .error (err) ->
        console.error "VisualizationService: ", "Error requesting route " + route, err
        done(false)
      .success (visualization) ->
        if Object.keys(visualization).length == 0
          console.error "VisualizationService: ", "no visualization with id " + id + " found"
          done(false)
        else
          console.log "VisualizationService: ", "found visualization: ", visualization
          done(visualization)

    findAll: (done)->
      route = '/api/visualizations/'

      if typeof done != 'function'
        throw "VisualizationService findAll need a callback function as argument"

      $http.get(route)
      .error (err) ->
        console.error "VisualizationService: ", "Error requesting route " + route, err
        done(false)
      .success (visualizations) ->
        console.log "VisualizationService: ", "found visualizations: ", visualizations
        visualizationMap = {}
        visualizations.map (v) ->
          visualizationMap[v.id] = v
        done(visualizationMap)

    findFiltered: (filters, done) ->
      route = '/api/visualizations?'
      for filter, query of filters
        route += filter + '=' + query + '&'

      if typeof done != 'function'
        throw "VisualizationService: findFiltered needs a callback function as argument"

      $http.get(route)
      .error (err) ->
        console.error "VisualizationService: ", "Error requesting route " + route, err
        done(false)
      .success (visualizations) ->
        visualizationMap = {}
        visualizations.map (visualization) ->
          visualizationMap[visualization.id] = visualization
        console.log "VisualizationService: ", "found visualizations: ", visualizationMap
        done(visualizationMap)

    # TODO: This may be too specific, use 'findFiltered' instead
    findPopular: (limit, done) ->
      route = '/api/visualizations/'

      if typeof done != 'function'
        throw "VisualizationService findPopular need a callback function as argument"

      $http.get(route)
      .error (err) ->
        console.error "VisualizationService: ", "Error requesting route " + route, err
        done(false)
      .success (visualizations) ->
        console.log "VisualizationService: ", "found visualizations: ", visualizations
        done(visualizations)


    create: (v, done) ->
      route = '/api/visualizations/'

      if typeof done != 'function'
        throw "VisualizationService create need a callback function as argument"

      $http.post(route, v)
      .error (err) ->
        console.error "VisualizationService: ", "Error requesting route " + route, err
        done(false)
      .success (visualization) ->
        console.log "VisualizationService: ", "created visualization: ", visualization
        done(visualization)

    update: (v, done) ->
      route = '/api/visualizations/' + v.id + '/edit'

      if typeof done != 'function'
        throw "VisualizationService create need a callback function as argument"

      $http.put(route, v)
      .error (err) ->
        console.error "VisualizationService: ", "Error requesting route " + route, err
        done(false)
      .success (visualization) ->
        console.log "VisualizationService: ", "updated visualization: ", visualization
        done(visualization)

    destroy: (vId, done) ->
      route = '/api/visualizations/' + vId

      if typeof done != 'function'
        throw "VisualizationService create need a callback function as argument"

      $http.delete(route)
      .error (err) ->
        console.error "VisualizationService: ", "Error requesting route " + route, err
        done(false)
      .success (res) ->
        console.log "VisualizationService: ", "deleted visualization with id = ", vId
        done(res)

    star: (vId, done) ->
      route = '/api/visualizations/' + vId + '/star'

      if typeof done != 'function'
        throw "VisualizationService star need a callback function as argument"

      $http.post(route)
      .error (err) ->
        console.error "VisualizationService: ", "Error requesting route " + route, err
        done(false)
      .success (res) ->
        console.log "VisualizationService: ", "starred visualization with id = ", vId
        done(res)

    unstar: (vId, done) ->
      route = '/api/visualizations/' + vId + '/star'

      if typeof done != 'function'
        throw "VisualizationService unstar need a callback function as argument"

      $http.delete(route)
      .error (err) ->
        console.error "VisualizationService: ", "Error requesting route " + route, err
        done(false)
      .success (res) ->
        console.log "VisualizationService: ", "unstarred visualization with id = ", vId
        done(res)

    postComment: (vId, comment, done) ->
      route = '/api/visualizations/' + vId + '/comment'

      if typeof done != 'function'
        throw "VisualizationService postComment need a callback function as argument"

      $http.post(route, comment)
      .error (err) ->
        console.error "VisualizationService: ", "Error requesting route " + route, err
        done(false)
      .success (res) ->
        console.log "VisualizationService: ", "comented on visualization with id = ", vId
        done(res)

    deleteComment: (vId, cId, done) ->
      route = '/api/visualizations/' + vId + '/comment/' + cId

      if typeof done != 'function'
        throw "VisualizationService removeComment need a callback function as argument"

      $http.delete(route)
      .error (err) ->
        console.error "VisualizationService: ", "Error requesting route " + route, err
        done(false)
      .success (res) ->
        console.log "VisualizationService: ", "removed comment with id = ", cId
        done(res)
  }
