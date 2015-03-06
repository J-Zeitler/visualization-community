'use strict'

##
# Date format directive, using momentJS
#
angular.module('community').directive 'formatDate', ->
  linker = (scope, element, attrs) ->
    model = attrs.formatDate
    scope.$watch model, (isoDate)->
      d = new Date(isoDate)
      if d != "Invalid Date"
        now = new Date().valueOf()
        before = d.valueOf()
        diffDays = (now - before)/(24*3600*1000)

        if diffDays > 1
          element[0].innerHTML = moment(d).calendar()
        else
          element[0].innerHTML = moment(d).fromNow()

  return {
    restrict: 'A'
    link: linker
  }