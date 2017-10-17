onLoadSubscribeForComments = ->
  if $('.answers')[0]
    subscription = App.cable.subscriptions.create { channel: 'CommentsChannel', question_id: gon.question_id },
      received: (data) ->
        console.log data
        if gon.current_user_id == data.user_id
          return
        commentable_type = data['commentable_type']
        answerPostfix = if commentable_type == 'Answer' then "[data-answer-id=#{data['commentable_id']}]" else ''
        $(".#{commentable_type.toLowerCase()}#{answerPostfix}>.comments>ul").append("<li>#{data['body']}</li>")
    cleanUpSubscriptionsFor(subscription)

$(document).on 'turbolinks:load', onLoadSubscribeForComments
