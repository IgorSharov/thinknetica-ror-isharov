App.cable.subscriptions.create 'QuestionsChannel',
  connected: ->
    console.log('Connected!')

  received: (data) ->
    console.log 'Received: ws'
    $('.questions').append data
