# frozen_string_literal: true

FactoryBot.define do
  sequence :title do |n|
    "Title#{n}"
  end
  sequence :body do |n|
    "Body#{n}"
  end

  factory :question do
    title
    body
    user

    factory :question_with_answers do
      after(:create) do |question|
        create_list(:answer, 3, question: question)
      end
    end

    factory :question_with_votes do
      after(:create) do |question|
        create_list(:vote, 3, votable: question)
      end
    end
  end

  factory :invalid_question, class: 'Question' do
    title nil
    body nil
    user
  end
end
