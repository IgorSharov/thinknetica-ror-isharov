# frozen_string_literal: true

require_relative '../acceptance_helper.rb'

RSpec.feature 'User removes his question', '
  In order to delete a question
  as a user
  I want to remove one of my questions
' do
  given!(:user) { create(:user) }
  given!(:question) { create(:question_with_answers, user: user) }

  scenario 'User removes his question' do
    sign_in user

    visit question_path(question)

    click_on 'Delete question'

    expect(page).to have_content 'Question successfully deleted.'
    expect(page).not_to have_content question.title
    expect(page).not_to have_content question.body
    expect(page).to have_current_path root_path
  end

  scenario 'User tries to remove someone else\'s question' do
    sign_in create(:user)

    visit question_path(question)

    expect(page).not_to have_content 'Delete question'
  end

  scenario 'Non-Authenticated user tries to remove a question' do
    visit question_path(question)

    expect(page).not_to have_content 'Delete question'
  end
end
