# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'User can see all questions', '
  In order to read all questions
  as a user
  I want to list all questions
' do
  scenario 'User see all questions' do
    visit questions_path

    expect(page).to have_content 'Questions'
  end
end

RSpec.feature 'User can create a question', '
  In order to ask a question
  as a user
  I want to create a question in the system
' do
  scenario 'User creates a new question' do
    visit questions_path

    click_on 'Ask question'

    expect(page).to have_content 'Ask your question'
    expect(page).to have_current_path new_question_path

    fill_in 'Title', with: 'My title'
    fill_in 'Body', with: 'My body'
    click_on 'Ask'

    expect(page).to have_content 'Questions'
    expect(page).to have_current_path root_path
  end
end
