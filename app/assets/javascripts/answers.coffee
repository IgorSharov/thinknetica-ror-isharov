# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

onLoadAnswers = ->
  $('.answers').on 'click', '.answer>a.answer_mark-as-best', (e) ->
    e.preventDefault()
    answer_id = $('.best-answer>.answer').data('answerId')
    if answer_id != undefined
      $('.answers').find("[data-answer-id='#{answer_id}']").show()
    answer_div = $(this).parent()
    answer_div_clone = answer_div.clone()
    answer_div_clone.find('h3').text('#BestAnswer')
    mark_href = answer_div_clone.find('a.answer_mark-as-best')
    mark_href.text('Unmark')
    mark_href.removeClass('answer_mark-as-best')
    mark_href.addClass('answer_unmark-best')
    mark_href.prop("href", (i,a) -> a.replace('bool=true','bool=false'))
    $('.best-answer').html(answer_div_clone)
    answer_div.hide()

  $('.answers').on 'click', '.answer>a.answer_unmark-best', (e) ->
    e.preventDefault()
    answer_id = $(this).parent().data('answerId')
    if answer_id != undefined
      $('.answers').find("[data-answer-id='#{answer_id}']").show()
    $(this).parent().remove()

  $('.answers').on 'click', '.answer>a.answer_edit', (e) ->
    e.preventDefault()
    edit_form_template = $('.answer-edit-form-tmp>form').clone()
    answer_id = $(this).parent().data('answerId')
    edit_form_template.prop('action', (i,a) -> a + '/' + answer_id)
    edit_form_template.find('textarea#answer_body').val($(this).parent().find('p').text())
    $(this).before(edit_form_template)

  $('.answers').on 'click', '.answer>a.answer_delete', (e) ->
    e.preventDefault()
    answer_id = $(this).parent().data('answerId')
    $(".answer[data-answer-id='#{answer_id}']").remove()

$(document).on('turbolinks:load', onLoadAnswers)
