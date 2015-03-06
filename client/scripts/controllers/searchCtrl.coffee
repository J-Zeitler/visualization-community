'use strict'

angular.module('community').controller 'SearchCtrl', ($scope, UserService, VisualizationService, $routeParams) ->
  $scope.visualizations = {}
  $scope.users = {}
  $scope.searchQuery = $routeParams.query.toLowerCase()

  # TODO: Implement more fine grained structure
  userFilter = {
    username: $scope.searchQuery
  }
  visualizationFilter = {
    title: $scope.searchQuery
    type: $scope.searchQuery
    description: $scope.searchQuery
  }

  UserService.findFiltered userFilter, (users) ->
    if !!users
      $scope.users = users
      $scope.usersFound = Object.keys(users).length > 0

  VisualizationService.findFiltered visualizationFilter, (visualizations) ->
    if !!visualizations
      $scope.visualizations = visualizations
      $scope.visualizationsFound = Object.keys(visualizations).length > 0
