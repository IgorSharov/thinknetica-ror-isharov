# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'User removes his answer', '
  In order to delete an answer
  as a user
  I want to remove one of my answers
' do
  given!(:question) { create(:question_with_answers) }
  given!(:user) { create(:user) }
  given!(:answer) { create(:answer, user: user, question: question) }

  scenario 'User removes his answer' do
    sign_in user

    visit question_path(question)

    expect { click_on 'Delete answer' }.to change(question.answers, :count).by(-1)
    expect(page).to have_current_path question_path(question)
  end

  scenario 'User tries to remove someone else\'s answer' do
    sign_in create(:user)

    visit question_path(question)

    expect(page).not_to have_content 'Delete answer'
  end
end
