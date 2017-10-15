# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
onLoadVotes = ->
  $('body')
    .on 'ajax:success', '.rating>a', (e, data, text, xhr) ->
      console.log 'vote'
      $('.alert').empty()
      $(this).parent().find('span').text(data.rating)
      if $(this).hasClass('chosen_link')
        $(this).removeClass('chosen_link')
        $(this).parent().find('a.disabled_link').removeClass('disabled_link')
      else
        $(this).addClass('chosen_link')
        $(this).parent().find('a').not('.chosen_link').addClass('disabled_link')

$(document).on('turbolinks:load', onLoadVotes)
