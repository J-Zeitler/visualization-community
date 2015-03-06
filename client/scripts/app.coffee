'use strict'

# app module
angular.module('community',
  ['ngRoute', 'angular-blocks', 'angular-growl', 'ngAnimate', 'angular-md5', 'ngCookies'])

  # Provider config
  .config ($routeProvider, $locationProvider, $httpProvider, growlProvider, $cookieStoreProvider) ->

    growlProvider.globalTimeToLive 5000

    $httpProvider.responseInterceptors.push ($q, $location) ->
      (promise) ->
        promise.then(
          (response) -> response,
          (response) ->
            console.log response
            if response.status == 401
              $location.url '/login'
            $q.reject response
        )

    $routeProvider
    .when '/',
      templateUrl: '/partials/feed',
      controller: 'FeedCtrl'

    .when '/login',
      templateUrl: '/partials/login',
      controller: 'LoginCtrl'

    .when '/signup',
      templateUrl: '/partials/signup',
      controller: 'SignupCtrl'

    .when '/profile/:id',
      templateUrl: '/partials/profile',
      controller: 'ProfileCtrl'

    .when '/visualization/:id',
      templateUrl: '/partials/visualization',
      controller: 'VisualizationCtrl'

    .when '/search/:query',
      templateUrl: '/partials/search',
      controller: 'SearchCtrl'
      
    .otherwise
      redirectTo: '/'

    $locationProvider.html5Mode true