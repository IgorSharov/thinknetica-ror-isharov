# frozen_string_literal: true

require_relative '../acceptance_helper.rb'

RSpec.feature 'User deletes file from a question', '
  In order to edit files attached to the question
  as its author
  I want to delete a file attached to the question
' do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given(:file) { create(:file, question: question) }

  scenario 'Authenticated user deletes file from a question' do
    sign_in user

    visit question_path(question)

    within('.attachment') do
      click_on 'Delete'
    end

    expect(page).to have_content 'File successfully deleted.'
    expect(page).not_to have_content file.name
  end

  scenario 'User can\'t delete file from another\'s question' do
    sign_in create(:user)

    visit question_path(question)

    within('.attachment') do
      expect(page).not_to have_link 'Delete'
    end
  end
end
