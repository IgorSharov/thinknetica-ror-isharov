# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

ready = ->
  $('.answer').on 'click', 'a', (e) ->
    $(this).replaceWith ->
      ("<span>" + $(this).html() + "</span>")

$(document).ready(ready)
$(document).on('turbolinks:load', ready)
