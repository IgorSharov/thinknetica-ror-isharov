# frozen_string_literal: true

FactoryBot.define do
  factory :vote do
    user
    vote_type { :up }
    value { 1 }
  end
end
