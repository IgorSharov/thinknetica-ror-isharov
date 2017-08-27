# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'User sees the question with answers', '
  In order to read all answers for the question
  as a user
  I want to list all the answers for the question
' do
  given(:question) { create(:question_with_answers) }

  scenario 'User see the question with all its answers' do
    visit question_path(question)

    expect(page.all('.answer').count).to eq question.answers.count
  end
end
