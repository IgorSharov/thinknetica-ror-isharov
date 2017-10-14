# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
onLoadComments = ->
  $(document)
    .on 'click', '.comments>a.comments_add-new', (e)->
      e.preventDefault()
      new_form_template = $('.new_comment-form-tmp>form').clone()
      if $(this).parent().parent().hasClass('answer')
        new_form_template.prop('action', (i,a) -> a.replace('question', 'answer'))
        object_id = $(this).parent().parent().data('answerId')
        new_form_template.prop('action', (i,a) -> a.replace('temp', object_id))
      else
        new_form_template.prop('action', (i,a) -> a.replace('temp', gon.question_id))
      $(this).before(new_form_template)
      $(this).hide()

    .on 'ajax:success', '.comments>form', (e, data, text, xhr) ->
      $('.alert').empty()
      $(this).find('.new_comment-errors.errors').empty()
      body = xhr.responseJSON['body']
      $(this).parent().find('ul').append("<li>#{body}</li>")
      $(this).parent().find('.comments_add-new').show()
      $(this).remove()

    .on "ajax:error", ".comments>form", (e, xhr, status, error) ->
      errors = xhr.responseJSON
      error_div = $(this).find('.new_comment-errors.errors')
      error_div.empty()
      for key, value of errors
        error_div.append("#{key}: #{value}")

$(document).on('turbolinks:load', onLoadComments)
