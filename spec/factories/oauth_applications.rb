# frozen_string_literal: true

FactoryGirl.define do
  factory :oauth_application, class: Doorkeeper::Application do
    name 'test'
    uid 'test_uid'
    secret 'test_secret'
    redirect_uri 'urn:ietf:wg:oauth:2.0:oob'
  end
end
