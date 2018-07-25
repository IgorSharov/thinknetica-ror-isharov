# frozen_string_literal: true

FactoryBot.define do
  sequence :email do |n|
    "user#{n}@test.com"
  end

  factory :user do
    email
    password 'f4k3p455w0rd'
    confirmed_at Time.current
  end
end
