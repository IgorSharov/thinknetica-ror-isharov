# frozen_string_literal: true

require_relative '../acceptance_helper.rb'

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

    title_text = 'Test title'
    body_text = 'Test body'

    fill_in 'Title', with: title_text
    fill_in 'Body', with: body_text
    click_on 'Ask'

    expect(page).to have_content 'Question was successfully created.'
    expect(page).to have_content title_text
    expect(page).to have_content body_text
    expect(page).to have_current_path root_path
  end

  scenario 'Authenticated user creates an empty question' do
    sign_in create(:user)

    visit questions_path

    click_on 'Ask question'

    expect(page).to have_content 'Ask your question'
    expect(page).to have_current_path new_question_path

    click_on 'Ask'

    expect(page).to have_content 'Question could not be created.'
    expect(page).to have_content 'titlecan\'t be blank'
    expect(page).to have_content 'bodycan\'t be blank'
  end

  scenario 'Non-Authenticated user creates a new question' do
    visit questions_path

    click_on 'Ask question'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
    expect(page).to have_current_path new_user_session_path
  end

  context 'multiple sessions', js: true do
    scenario 'question appears on another user\'s page' do
      title_text = 'Test title'
      body_text = 'Test body'

      sign_in create(:user)
      visit questions_path

      Capybara.using_session('guest') do
        visit questions_path
      end

      click_on 'Ask question'

      expect(page).to have_content 'Ask your question'
      expect(page).to have_current_path new_question_path

      fill_in 'Title', with: title_text
      fill_in 'Body', with: body_text
      click_on 'Ask'

      expect(page).to have_content 'Question was successfully created.'
      expect(page).to have_content title_text
      expect(page).to have_content body_text
      expect(page).to have_current_path root_path

      Capybara.using_session('guest') do
        expect(page).to have_content title_text
        expect(page).to have_content body_text
      end
    end
  end
end
