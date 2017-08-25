# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'User answers a question', '
  In order to answer a question
  as a user
  I want to add an answer to the question
' do
  given(:question) { create(:question) }

  scenario 'Authenticated user answers the question' do
    sign_in create(:user)

    visit question_path(question)
    click_on 'Add answer'

    expect(page).to have_current_path new_question_answer_path(question)

    answer_text = 'Answer body'

    fill_in 'Body', with: answer_text
    click_on 'Answer'

    expect(page).to have_current_path question_path(question)
    expect(page).to have_content answer_text
  end

  scenario 'Non-Authenticated user answers the question' do
    visit question_path(question)

    click_on 'Add answer'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
    expect(page).to have_current_path new_user_session_path
  end
end

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
