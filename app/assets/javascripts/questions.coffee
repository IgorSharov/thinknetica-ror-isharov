# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
onLoadQuestions = ->
  $('.question-actions-bar>a').filter((index) -> $(this).text() == 'Edit').click (e) ->
    e.preventDefault();
    $('.question-actions-bar').hide()
    $('.edit_question').show()
    $('.alert').empty();
    $('.notice').empty();

$(document).on('turbolinks:load', onLoadQuestions)
