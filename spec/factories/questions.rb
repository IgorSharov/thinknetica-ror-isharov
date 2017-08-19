# frozen_string_literal: true

FactoryGirl.define do
  sequence :title do |n|
    "Title#{n}"
  end
  sequence :body do |n|
    "Body#{n}"
  end

  factory :question do
    title
    body

    factory :question_with_answer do
      after(:create) do |question|
        create_list(:answer, 3, question: question)
      end
    end
  end

  factory :invalid_question, class: 'Question' do
    title nil
    body nil
  end
end
