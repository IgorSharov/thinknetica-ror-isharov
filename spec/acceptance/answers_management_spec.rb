# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'User can answer a question', '
  In order to answer a question
  as a user
  I want to add an answer to the question
' do
  given(:question) { create(:question) }

  scenario 'User answers the question' do
    visit question_path(question)

    click_on 'Add answer'

    expect(page).to have_current_path new_question_answer_path(question)

    answer_text = 'Answer body'

    fill_in 'Body', with: answer_text
    click_on 'Answer'

    expect(page).to have_current_path question_path(question)
    expect(page).to have_content answer_text
  end
end
