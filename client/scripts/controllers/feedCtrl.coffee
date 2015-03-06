'use strict'

angular.module('community').controller 'FeedCtrl', ($scope, AuthService, ActivityService, VisualizationService) ->
  $scope.activities = []

  AuthService.getCurrentUser(yes).then (user) ->
    # ActivityService.findByUserId user.id, (res) ->
    #   if !!res
    #     $scope.myActivities = res
    ActivityService.findFiltered {userIds: user.followees.concat(user.id)}, (res) ->
      if !!res
        $scope.activities = res

  VisualizationService.findPopular 10, (visualizations) ->
    if !!visualizations
      $scope.popularVisualizations = visualizations
