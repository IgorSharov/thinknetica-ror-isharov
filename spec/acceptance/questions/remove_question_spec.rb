# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'User removes his question', '
  In order to delete a question
  as a user
  I want to remove one of my questions
' do
  given(:question) { create(:question_with_answers) }

  scenario 'User removes his question' do
    sign_in question.user

    visit question_path(question)

    expect(page).to have_css('body>form.button_to>input[type="submit"][value="Delete question"]')

    click_on 'Delete question'

    expect(page).to have_current_path root_path
  end

  scenario 'User tries to remove someone else\'s question' do
    sign_in create(:user)

    visit question_path(question)

    expect(page).not_to have_css('body>form.button_to>input[type="submit"][value="Delete question"]')
  end
end
