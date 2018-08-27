# frozen_string_literal: true

require_relative '../acceptance_initializer.rb'

RSpec.feature 'User comments a question or an answer', '
  In order to clarify a quetion/ an answer
  as a user
  I want comment it
', js: true do
  given(:question_comment_text) { 'Comment for question' }
  given(:answer_comment_text) { 'Comment for answer' }
  given(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question) }

  scenario 'Authenticated user comments something' do
    sign_in create(:user)

    visit question_path(question)

    within('.question') do
      click_on 'Add comment'
      fill_in 'Comment:', with: question_comment_text
      click_on 'Ok'
      wait_for_ajax

      expect(page).to have_content question_comment_text
    end

    within('.answer') do
      click_on 'Add comment'
      fill_in 'Comment:', with: answer_comment_text
      click_on 'Ok'
      wait_for_ajax

      expect(page).to have_content answer_comment_text
    end
  end

  scenario 'Non-authenticated user can comment nothing' do
    visit question_path(question)

    expect(page).not_to have_link 'Add comment'
  end

  context 'multiple sessions', js: true do
    scenario 'comments appear on another user\'s page' do
      sign_in create(:user)
      visit question_path(question)

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      within('.question') do
        click_on 'Add comment'
        fill_in 'Comment:', with: question_comment_text
        click_on 'Ok'
        wait_for_ajax

        expect(page).to have_content question_comment_text
      end

      within('.answer') do
        click_on 'Add comment'
        fill_in 'Comment:', with: answer_comment_text
        click_on 'Ok'
        wait_for_ajax

        expect(page).to have_content answer_comment_text
      end

      Capybara.using_session('guest') do
        expect(page).to have_content question_comment_text
        expect(page).to have_content answer_comment_text
      end
    end
  end
end
