# frozen_string_literal: true

require_relative '../acceptance_helper.rb'

RSpec.feature 'User answers a question', '
  In order to answer a question
  as a user
  I want to add an answer to the question
', js: true do
  given(:question) { create(:question) }

  scenario 'Authenticated user answers the question' do
    sign_in create(:user)

    visit question_path(question)

    answer_text = 'Answer body'
    fill_in 'Your answer:', with: answer_text

    click_on 'Add answer'
    wait_for_ajax

    expect(page).to have_content 'Answer was successfully created.'
    expect(page).to have_content answer_text
  end

  scenario 'Authenticated user gives empty answer to the question' do
    sign_in create(:user)

    visit question_path(question)

    click_on 'Add answer'

    expect(page).to have_content 'Answer could not be created.'
    expect(page.text).to match(/^body\Rcan\'t be blank$/)
  end

  scenario 'Non-Authenticated user answers the question' do
    visit question_path(question)

    click_on 'Add answer'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end

  context 'multiple sessions' do
    scenario 'question appears on another user\'s page' do
      answer_text = 'Test answer body'

      sign_in create(:user)
      visit question_path(question)

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      fill_in 'Your answer:', with: answer_text

      click_on 'Add answer'
      wait_for_ajax

      expect(page).to have_content 'Answer was successfully created.'
      expect(page).to have_content answer_text

      Capybara.using_session('guest') do
        expect(page).to have_content answer_text
      end
    end
  end
end
