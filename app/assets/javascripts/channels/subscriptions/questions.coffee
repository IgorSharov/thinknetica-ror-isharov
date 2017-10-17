onLoadSubscribeForQuestions = ->
  if $('.questions')[0]
    subscription = App.cable.subscriptions.create 'QuestionsChannel',
      received: (data) ->
        console.log data
        $('.questions').append data
    cleanUpSubscriptionsFor(subscription)

$(document).on 'turbolinks:load', onLoadSubscribeForQuestions
