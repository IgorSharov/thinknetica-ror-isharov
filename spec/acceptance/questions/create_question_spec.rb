# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'User creates a question', '
  In order to ask a question
  as a user
  I want to create a question in the system
' do
  scenario 'Authenticated user creates a new question' do
    sign_in create(:user)

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

  scenario 'Non-Authenticated user creates a new question' do
    visit questions_path

    click_on 'Ask question'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
    expect(page).to have_current_path new_user_session_path
  end
end
