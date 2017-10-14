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

    expect(page).to have_content 'Answer successfully created.'
    expect(page).to have_content answer_text
  end

  scenario 'Authenticated user gives empty answer to the question' do
    sign_in create(:user)

    visit question_path(question)

    click_on 'Add answer'

    expect(page).to have_content 'An error occurred while creating the answer!'
    expect(page).to have_content 'body can\'t be blank'
  end

  scenario 'Non-Authenticated user answers the question' do
    visit question_path(question)

    click_on 'Add answer'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end

  context 'multiple sessions', js: true do
    scenario 'question appears on another user\'s page' do
      answer_text = 'Test answer body'

      Capybara.using_session('user') do
        sign_in create(:user)
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        fill_in 'Your answer:', with: answer_text

        click_on 'Add answer'
        wait_for_ajax

        expect(page).to have_content 'Answer successfully created.'
        expect(page).to have_content answer_text
      end

      Capybara.using_session('guest') do
        expect(page).to have_content answer_text
      end
    end
  end
end
