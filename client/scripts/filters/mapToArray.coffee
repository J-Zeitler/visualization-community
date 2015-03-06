'use strict'

angular.module('community').filter 'mapToArray', ->
  return (map, key) ->
    arr = [];
    if typeof map == 'object'
      Object.keys(map).forEach (key)->
        arr.push map[key]
    return arr