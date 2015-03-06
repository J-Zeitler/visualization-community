'use strict'

##
# Display a tooltip with the provided message
#
angular.module('community').directive 'tooltip', ->
    
    linker = (scope, element, attrs) ->
      text = attrs.tooltip
      $(element).tooltip({
        placement: 'bottom'
        title: text
      })

    return {
      restrict: 'A'
      link: linker
    }

