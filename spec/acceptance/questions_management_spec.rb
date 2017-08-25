# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'User can create a question', '
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

RSpec.feature 'User can see all questions', '
  In order to read all questions
  as a user
  I want to list all questions
' do
  scenario 'User see all questions' do
    visit questions_path

    expect(page).to have_content 'Questions'
  end
end

RSpec.feature 'User can see the question with answers', '
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

RSpec.feature 'User can remove his question', '
  In order to remove a question
  as a user
  I want to destroy one of my questions
' do
  scenario 'User removes his question'

  scenario 'User removes someone else\'s question'
end
