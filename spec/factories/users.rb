# frozen_string_literal: true

FactoryGirl.define do
  sequence :email do |n|
    "user#{n}@test.com"
  end

  factory :user do
    email
    password 'f4k3p455w0rd'
    confirmed_at DateTime.current
  end
end
