# frozen_string_literal: true

FactoryBot.define do
  factory :access_token, class: Doorkeeper::AccessToken do
    application_id { create(:oauth_application).id }
    resource_owner_id { create(:user).id }
  end
end
