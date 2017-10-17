onLoadSubscribeForAnswers = ->
  if $('.answers')[0]
    subscription = App.cable.subscriptions.create { channel: 'AnswersChannel', question_id: gon.question_id },
      received: (data) ->
        console.log data
        if gon.current_user_id == data.user_id
          return
        $('.answers').append(JST['templates/answer']({answer: data}))
    cleanUpSubscriptionsFor(subscription)

$(document).on 'turbolinks:load', onLoadSubscribeForAnswers
