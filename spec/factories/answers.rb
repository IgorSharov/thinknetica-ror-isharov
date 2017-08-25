# frozen_string_literal: true

FactoryGirl.define do
  factory :answer do
    body
    question
    user
  end

  factory :invalid_answer, class: 'Answer' do
    body nil
    question
    user
  end
end
