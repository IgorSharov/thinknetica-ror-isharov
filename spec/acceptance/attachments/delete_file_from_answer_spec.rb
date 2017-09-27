# frozen_string_literal: true

require_relative '../acceptance_helper.rb'

RSpec.feature 'User deletes file from an answer', '
  In order to edit files attached to the answer
  as its author
  I want to delete a file attached to the answer
' do
  given(:user) { create(:user) }
  given!(:question) { create(:question) }
  given(:file) { create(:file, question: question) }

  scenario 'Authenticated user deletes file from an answer' do
    sign_in user

    visit question_path(question)

    within('.attachment') do
      click_on 'Delete'
    end

    expect(page).to have_content 'File successfully deleted.'
    expect(page).not_to have_content file.name
  end

  scenario 'User can\'t delete file from another\'s answer' do
    sign_in create(:user)

    visit question_path(question)

    within('.attachment') do
      expect(page).not_to have_link 'Delete'
    end
  end
end
