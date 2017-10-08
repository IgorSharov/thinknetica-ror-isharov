# frozen_string_literal: true

FactoryGirl.define do
  factory :answer do
    body
    question
    user

    factory :answer_with_votes do
      after(:create) do |answer|
        create_list(:vote, 3, votable: answer)
      end
    end
  end

  factory :invalid_answer, class: 'Answer' do
    body nil
    question
    user
  end
end
