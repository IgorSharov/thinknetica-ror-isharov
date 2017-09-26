# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

onLoadAttachments = ->
  $('.attachments').on 'click', '.attachment>a.attachment_delete', (e) ->
    e.preventDefault()
    answer_id = $(this).parent().remove()

$(document).on('turbolinks:load', onLoadAttachments)
