// Action Cable provides the framework to deal with WebSockets in Rails.
// You can generate new channels where WebSocket features live using the `rails generate channel` command.
//
//= require action_cable
//= require_self
//= require_tree ./channels

(function() {
    this.App || (this.App = {});

    App.cable = ActionCable.createConsumer();

}).call(this);

function cleanUpSubscriptionsFor(subscription) {
    let subscriptionIdentifier = JSON.parse(subscription.identifier);
    App.cable.subscriptions.subscriptions.forEach(function(element) {
        let elementIdentifier = JSON.parse(element.identifier);
        if (subscription !== element &&
            elementIdentifier['question_id'] != subscriptionIdentifier['question_id']) {
            App.cable.subscriptions.forget(element);
        }
    });
}