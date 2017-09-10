# frozen_string_literal: true

require_relative '../acceptance_helper.rb'

RSpec.feature 'User edits his question', '
  In order to clarify my question
  as a user
  I want to edit my question in the system
', js: true do
  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }

  scenario 'Author edits his question' do
    sign_in user

    visit question_path(question)

    edited_title = 'New title'
    edited_body = 'New body'

    within('.question') do
      click_on 'Edit'
      fill_in 'Title', with: edited_title
      fill_in 'Body', with: edited_body
      click_on 'Ok'

      expect(page).to have_content edited_title
      expect(page).to have_content edited_body
    end

    expect(page).to have_content 'Question successfully updated.'
  end

  scenario 'User can\'t edit another\'s question' do
    sign_in create(:user)

    visit question_path(question)

    within('.question') do
      expect(page).not_to have_link 'Edit'
    end
  end

  scenario 'Non-Authenticated user can\'t edit any question' do
    visit question_path(question)

    within('.question') do
      expect(page).not_to have_link 'Edit'
    end
  end
end
