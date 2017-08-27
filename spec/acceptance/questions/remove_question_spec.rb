# frozen_string_literal: true

require 'rails_helper'

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

    expect { click_on 'Delete question' }.to change(Question, :count).by(-1).and \
      change(Answer, :count).by(-question.answers.count)
    expect(page).to have_content('Question successfully deleted.')
    expect(page).to have_current_path root_path
  end

  scenario 'User tries to remove someone else\'s question' do
    sign_in create(:user)

    visit question_path(question)
    expect(page).not_to have_content('Delete question')
  end
end
