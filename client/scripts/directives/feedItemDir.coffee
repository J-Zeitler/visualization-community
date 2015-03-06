'use strict'

##
# Load the appropriate html template for an activity in the feed.
#
angular.module('community').directive 'feedItem', ($compile, $http, $q, $templateCache) ->

  getTemplate = (type) ->
    baseUrl = '/partials/templates/'
    templateMap = {
      userUpdate: 'feedUserUpdate.html'
      userCreate: 'feedUserCreate.html'
      visualizationUpdate: 'feedVisualizationUpdate.html'
      visualizationCreate: 'feedVisualizationCreate.html'
    }

    templateUrl = baseUrl + '/' + templateMap[type]
    templateLoader = $http.get templateUrl, {cache: $templateCache}

    return templateLoader

  linker = (scope, element, attrs) ->
    type = ""
    
    if scope.feedItem.hasOwnProperty('VisualizationId') && scope.feedItem.action == "updated"
      type = 'visualizationUpdate'
    else if scope.feedItem.hasOwnProperty('VisualizationId') && scope.feedItem.action == "created"
      type = 'visualizationCreate'
    else if scope.feedItem.hasOwnProperty('UserId') && scope.feedItem.action == "updated"
      type = 'userUpdate'
    else if scope.feedItem.hasOwnProperty('UserId') && scope.feedItem.action == "created"
      type = 'userCreate'

    loader = getTemplate(type).success (html) ->
      element.html html
      element.replaceWith($compile(element.html())(scope))

  return {
    link: linker
    restrict: 'A'
    scope: {
      feedItem: '='
    }
  }