# frozen_string_literal: true

require_relative '../acceptance_initializer.rb'

RSpec.feature 'User edits his answer', '
  In order to clarify my answer
  as a user
  I want to edit my answer in the system
', js: true do
  given(:question) { create(:question) }
  given(:user) { create(:user) }
  given!(:answer) { create(:answer, user: user, question: question) }

  scenario 'Author edits his answer' do
    sign_in user

    visit question_path(question)

    edited_body = 'Edited body text'

    within('.answer') do
      click_on 'Edit'
      fill_in 'Edit your answer:', with: edited_body
      click_on 'Ok'

      expect(page).to have_content edited_body
    end

    expect(page).to have_content 'Answer was successfully updated.'
    expect(page).not_to have_content answer.body
    expect(page).not_to have_selector '.answer>textarea'
  end

  scenario 'User can\'t edit another\'s answer' do
    sign_in create(:user)

    visit question_path(question)

    within('.answer') do
      expect(page).not_to have_link 'Edit'
    end
  end

  scenario 'Non-Authenticated user can\'t edit any answer' do
    visit question_path(question)

    within('.answer') do
      expect(page).not_to have_link 'Edit'
    end
  end
end
