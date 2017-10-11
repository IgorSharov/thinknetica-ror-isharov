$ ->
  if $('.questions')[0]
    App.cable.subscriptions.create 'QuestionsChannel',
      received: (data) ->
        console.log 'Received: new question'
        $('.questions').append data
