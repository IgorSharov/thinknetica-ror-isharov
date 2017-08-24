# frozen_string_literal: true

FactoryGirl.define do
  factory :user do
    email 'user@test.com'
    password 'f4k3p455w0rd'
  end
end
