# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'User creates a question', '
  In order to ask a question
  as a user
  I want to create a question in the system
' do
  scenario 'Authenticated user creates a new question' do
    sign_in create(:user)

    visit questions_path

    click_on 'Ask question'

    expect(page).to have_content 'Ask your question'
    expect(page).to have_current_path new_question_path

    fill_in 'Title', with: 'My title'
    fill_in 'Body', with: 'My body'
    click_on 'Ask'

    expect(page).to have_content 'Questions'
    expect(page).to have_current_path root_path
  end

  scenario 'Non-Authenticated user creates a new question' do
    visit questions_path

    click_on 'Ask question'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
    expect(page).to have_current_path new_user_session_path
  end
end

RSpec.feature 'User sees all questions', '
  In order to read all questions
  as a user
  I want to list all questions
' do
  scenario 'User see all questions' do
    visit questions_path

    expect(page).to have_content 'Questions'
  end
end

RSpec.feature 'User sees the question with answers', '
  In order to read all answers for the question
  as a user
  I want to list all the answers for the question
' do
  given(:question) { create(:question_with_answers) }

  scenario 'User see the question with all its answers' do
    visit question_path(question)

    expect(page.all('.answer').count).to eq question.answers.count
  end
end

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
