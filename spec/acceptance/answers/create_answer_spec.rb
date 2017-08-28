# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'User answers a question', '
  In order to answer a question
  as a user
  I want to add an answer to the question
' do
  given(:question) { create(:question) }

  scenario 'Authenticated user answers the question' do
    sign_in create(:user)

    visit question_path(question)

    answer_text = 'Answer body'
    fill_in 'Body', with: answer_text

    click_on 'Add answer'

    expect(page).to have_content 'Answer successfully created.'
    expect(page).to have_content answer_text
  end

  scenario 'Authenticated user gives empty answer to the question' do
    sign_in create(:user)

    visit question_path(question)

    click_on 'Add answer'

    expect(page).to have_content 'An error occurred while creating the answer!'
    expect(page).to have_content 'bodycan\'t be blank'
  end

  scenario 'Non-Authenticated user answers the question' do
    visit question_path(question)

    click_on 'Add answer'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
    expect(page).to have_current_path new_user_session_path
  end
end
