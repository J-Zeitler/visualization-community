'use strict'

angular.module('community').controller 'VisualizationCtrl', ($scope, $routeParams, VisualizationService, $location, growl)->
  $scope.id = $routeParams.id
  $scope.visualization = {}
  $scope.editable = false
  $scope.starred = false

  $scope.loadVisualization = ->
    VisualizationService.findById $scope.id, (res)->
      if !!res
        $scope.visualization = res
        $scope.starred = res.starredBy.indexOf($scope.currentUser.id) >= 0
        $scope.editable = res.UserId == $scope.currentUser.id

  $scope.loadVisualization()

  ##
  # Stars
  #
  $scope.starVisualization = ->
    VisualizationService.star $scope.id, (res) ->
      if !!res
        $scope.loadVisualization()

  $scope.unstarVisualization = ->
    VisualizationService.unstar $scope.id, (res) ->
      if !!res
        $scope.loadVisualization()

  ##
  # Comments
  #
  $scope.postComment = (c) ->
    VisualizationService.postComment $scope.id, c, (res) ->
      if !!res
        $scope.visualization.comments.push(res)
        c.text = ""

  $scope.deleteComment = (c) ->
    VisualizationService.deleteComment $scope.id, c.id, (res) ->
      if !!res
        idx = $scope.visualization.comments.indexOf(c)
        $scope.visualization.comments.splice(idx, 1)

  ##
  # Edit functions
  # TODO: Code duplication, generalize in a service
  # 
  $scope.validateInput = (v) ->
    if !!v && v.hasOwnProperty('title') && v.hasOwnProperty('type') && v.hasOwnProperty('description') && v.title != "" && v.type != "" && v.description != ""
      return true
    else
      return false

  $scope.updateVisualization = (v) ->
    if $scope.validateInput(v)
      VisualizationService.update v, (res) ->
        growl.addSuccessMessage "Visualization updated"
    else
      $scope.cancelUpdate(v.id)
      growl.addErrorMessage "Invalid visualization fields"        

  $scope.deleteVisualization = (v) ->
    VisualizationService.destroy v.id, (res) ->
      $location.path '/profile/' + $scope.currentUser.id
      growl.addSuccessMessage "Visualization deleted"

  $scope.cancelUpdate = (vId) ->
    VisualizationService.findById vId, (v) ->
      $scope.visualization = v
