# frozen_string_literal: true

FactoryBot.define do
  factory :auth_account do
    user nil
    provider 'MyString'
    uid 'MyString'
  end
end
