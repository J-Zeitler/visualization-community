'use strict'

##
# Used to highlight an a-tag with the class 'active' on matching URL.
#
angular.module('community')
  .directive 'activatable', ($location) ->
    linker = (scope, element, attributes) ->
      href = $(element).find("a")[0].href
      currentPath = $location.absUrl()

      if href == currentPath
        element.addClass 'active'

    return {
      restrict: 'A'
      link: linker
    }