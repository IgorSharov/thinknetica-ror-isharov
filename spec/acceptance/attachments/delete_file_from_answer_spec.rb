# frozen_string_literal: true

require_relative '../acceptance_helper.rb'

RSpec.feature 'User deletes file from an answer', '
  In order to edit files attached to the answer
  as its author
  I want to delete a file attached to the answer
', js: true do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:answer) { create(:answer, question: question, user: user) }
  given!(:attachment) { create(:attachment, attachable: answer) }

  scenario 'Authenticated user deletes file from an answer' do
    sign_in user

    visit question_path(question)

    within('.answer>.attachments') do
      click_on 'remove'
    end

    expect(page).to have_content 'Attachment successfully deleted.'
    expect(page).not_to have_content attachment.file.filename
  end

  scenario 'User can\'t delete file from another\'s answer' do
    sign_in create(:user)

    visit question_path(question)

    within('.attachment') do
      expect(page).not_to have_content 'remove'
    end
  end
end
