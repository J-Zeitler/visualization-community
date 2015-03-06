'use strict'

##
# Attach click listener to toggle-animate elements with the provided id/class
#
angular.module('community').directive 'toggles', ->
  linker = (scope, element, attrs) ->
    targets = $("." + attrs.toggles)
    targets.push $("#" + attrs.toggles)[0]

    $(element).on 'click', (e) ->
      e.preventDefault()
      for target in targets
        $(target).slideToggle('fast')


  return {
    restrict: 'A'
    link: linker
  }
