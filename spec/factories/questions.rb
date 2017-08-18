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
  end

  factory :invalid_question, class: 'Question' do
    title nil
    body nil
  end
end
