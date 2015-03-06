'use strict'

angular.module('community')
  .controller 'LoginCtrl', ($scope, AuthService, $location, growl) ->
    console.log "LoginCtrl loaded"

    $scope.loginSuccess = ->
      console.log "LoginCtrl: ", "Login successful, redirecting to '/'"
      $location.path '/'

    $scope.loginFail = ->
      growl.addErrorMessage "Invalid user credentials"

    $scope.login = () ->
      console.log "LoginCtrl: ", "Attempting to login user", $scope.user
      AuthService.loginLocal $scope.user, $scope.loginSuccess, $scope.loginFail
