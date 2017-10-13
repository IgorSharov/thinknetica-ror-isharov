onLoadSubscribeAnswers = ->
  if $('.answers')[0]
    subscription = App.cable.subscriptions.create { channel: 'AnswersChannel', question_id: gon.question_id },
      received: (data) ->
        answer = JSON.parse(data)
        console.log answer
        if gon.current_user_id != answer.user_id
          $('.answers').append(JST['templates/answer']({answer: answer}))
    killAllChannelsExcept(subscription)

$(document).on 'turbolinks:load', onLoadSubscribeAnswers
