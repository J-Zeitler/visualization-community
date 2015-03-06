'use strict'

##
# Main controller, wrapping the entire application.
#
angular.module('community').controller 'MainCtrl', ($scope, AuthService, md5, $location) ->
  console.log "MainCtrl loaded"

  $scope.isLoggedIn = false
  $scope.currentUser = {}

  $scope.logout = ->
    AuthService.logout()

  $scope.$watch AuthService.isLoggedIn, (isLoggedIn) ->
    $scope.isLoggedIn = isLoggedIn
    if isLoggedIn
      promise = AuthService.getCurrentUser()
      promise.then (user) ->
        $scope.currentUser = user

  AuthService.checkLoggedIn()

  $scope.searchRedirect = (query) ->
    console.log "redirecting"
    $location.path "/search/" + query
