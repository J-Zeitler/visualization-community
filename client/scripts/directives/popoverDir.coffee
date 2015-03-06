'use strict'

##
# Attach a popover click event to the element to display a dialog popover with the provided config.
#
angular.module('community').directive 'popover', ($compile) ->
  $(document).on 'click', (e) ->
    $('[popover]').popover 'hide'

  linker = (scope, element, attrs) ->
    id = "popper" + Math.random()
    title = attrs.popover
    btnText = attrs.popoverBtnText
    btnType = attrs.popoverBtnType
    action = attrs.popoverAction
    template = "<div id='#{id}' class='btn-group'><button class='btn #{btnType}' ng-click='#{action}'>#{btnText}</button><button class='btn btn-default'>Cancel</button></div>"
    
    $(element).popover({
      title: title
      content: template
      html: true
      trigger: 'manual'
    }).on 'click', (e) ->
      $(this).popover 'toggle'
      $compile($(this).siblings('.popover').contents())(scope)
      e.stopPropagation()

  return {
    restrict: 'A'
    link: linker
  }