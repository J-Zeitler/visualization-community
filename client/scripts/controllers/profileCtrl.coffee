'use strict'

angular.module('community')
  .controller 'ProfileCtrl', ($scope, $routeParams, UserService, VisualizationService, growl)->
    $scope.user = {}
    $scope.editable = false
    $scope.followed = false
    $scope.profileId = parseInt $routeParams.id

    UserService.findById $scope.profileId, (res)->
      if !!res
        $scope.user = res
        $scope.followed = $scope.currentUser.followees.indexOf($scope.profileId) >= 0
        $scope.editable = $scope.user.id == $scope.currentUser.id

    $scope.followUser = ->
      UserService.followUser $scope.user.id, (res) ->
        if !!res
          $scope.followed = true
          $scope.currentUser.followees.push($scope.user.id)
          growl.addSuccessMessage "Now following " + $scope.user.username

    $scope.unfollowUser = ->
      UserService.unfollowUser $scope.user.id, (res) ->
        if !!res
          $scope.followed = false
          delete $scope.currentUser.followees[$scope.currentUser.followees.indexOf($scope.user.id)]
          growl.addSuccessMessage "Unfollowed " + $scope.user.username

    $scope.updateUser = (u) ->
      if $scope.validateUser(u)
        UserService.update u, (res) ->
          growl.addSuccessMessage "Profile updated"
      else
        $scope.cancelUserUpdate(u.id)
        growl.addErrorMessage "Invalid profile fields"

    $scope.validateUser = (u) ->
      if !!u && u.hasOwnProperty('username') && u.hasOwnProperty('email') && u.username != "" && u.email != ""
        return true
      else
        return false

    $scope.cancelUserUpdate = (uId) ->
      UserService.findById uId, (u) ->
        $scope.user = u

    # TODO: this should be generalized in a service
    $scope.createVisualization = (v) ->
      if $scope.validateInput(v)
        VisualizationService.create v, (res) ->
          if !!res
            growl.addSuccessMessage "Visualization created"
            $scope.user.visualizations[res.id] = res
      else
        growl.addErrorMessage "Invalid visualization fields"

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
        delete $scope.user.visualizations[v.id]
        growl.addSuccessMessage "Visualization deleted"

    $scope.cancelUpdate = (vId) ->
      VisualizationService.findById vId, (v) ->
        $scope.user.visualizations[vId] = v

    