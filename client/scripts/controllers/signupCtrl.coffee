'use strict'

angular.module('community')
  .controller 'SignupCtrl', ($scope, AuthService, $http, $location)->
    console.log 'SignupCtrl loaded'

    $scope.signup = () ->
      $http.post('/api/users/', $scope.newUser)
        .success (res) ->
          # console.log "SignupCtrl: ", "User ", $scope.newUser, " created"
          # console.log "SignupCtrl: ", "Attempting to login user", $scope.user
          AuthService.loginLocal $scope.newUser, ->
            if AuthService.isLoggedIn()
              # console.log "SignupCtrl: ", "Sign up successful, redirecting to '/'"
              $location.path '/'
