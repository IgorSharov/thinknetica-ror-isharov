# frozen_string_literal: true

require_relative '../acceptance_helper.rb'

RSpec.feature 'User adds files to a question', '
  In order to clarify a question
  as a user
  I want to attach files to a question
' do
  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }

  background do
    sign_in user
  end

  scenario 'Authenticated user attaches files to a new question' do
    visit new_question_path

    fill_in 'Title', with: 'Test title'
    fill_in 'Body', with: 'Test body'

    click_on 'Add file'
    attach_file 'File', file_fixture('test_file.txt')

    click_on 'Add file'
    attach_file 'File', file_fixture('test_file_2.txt')

    click_on 'Ask'

    click_on 'Show'

    expect(page).to have_content 'test_file.txt'
    expect(page).to have_content 'test_file_2.txt'
  end

  scenario 'Author of a question adds files to it' do
    visit question_path(question)

    click_on 'Edit'

    click_on 'Add file'
    attach_file 'File', file_fixture('test_file.txt')

    click_on 'Add file'
    attach_file 'File', file_fixture('test_file_2.txt')

    click_on 'Ok'

    expect(page).to have_content 'test_file.txt'
    expect(page).to have_content 'test_file_2.txt'
  end
end
