onLoadSubscribeAnswers = ->
  if $('.answers')[0]
    App.cable.subscriptions.create { channel: 'AnswersChannel', question_id: gon.question_id },
      received: (answer) ->
        console.log answer
        # $('.answers').append(JST['templates/answer']({answer: answer}))

$(document).on 'turbolinks:load', onLoadSubscribeAnswers
