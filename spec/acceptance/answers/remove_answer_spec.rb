# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'User removes his answer', '
  In order to delete an answer
  as a user
  I want to remove one of my answers
' do
  given!(:question) { create(:question_with_answers) }

  scenario 'User removes his question' do
    user = create(:user)
    answer = question.answers.first
    answer.user = user
    answer.save!

    sign_in user

    visit question_path(question)

    expect(page).to have_css('.answer>a[data-method="delete"]')

    click_on 'Delete answer'

    expect(page).to have_current_path question_path(question)
  end

  scenario 'User tries to remove someone else\'s question' do
    sign_in create(:user)

    visit question_path(question)

    expect(page).not_to have_css('.answer>a[data-method="delete"]')
  end
end
