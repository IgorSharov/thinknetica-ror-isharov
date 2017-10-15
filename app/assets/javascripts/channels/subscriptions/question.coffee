onLoadSubscribeQuestion = ->
  if $('.answers')[0]
    subscription = App.cable.subscriptions.create { channel: 'QuestionChannel', question_id: gon.question_id },
      received: (data) ->
        jsonData = JSON.parse(data)
        console.log jsonData
        if gon.current_user_id == jsonData.user_id
          return
        commentable_type = jsonData['commentable_type']
        if commentable_type
          answerPostfix = if commentable_type == 'Answer' then "[data-answer-id=#{jsonData['commentable_id']}]" else ''
          $(".#{commentable_type.toLowerCase()}#{answerPostfix}>.comments>ul").append("<li>#{jsonData['body']}</li>")
        else
          $('.answers').append(JST['templates/answer']({answer: jsonData}))
    killAllChannelsExcept(subscription)

$(document).on 'turbolinks:load', onLoadSubscribeQuestion
