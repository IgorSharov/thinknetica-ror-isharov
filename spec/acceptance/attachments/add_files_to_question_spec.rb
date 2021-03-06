# frozen_string_literal: true

require_relative '../acceptance_helper.rb'

RSpec.feature 'User adds files to a question', '
  In order to clarify a question
  as a user
  I want to attach files to a question
', js: true do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }

  background do
    sign_in user
  end

  scenario 'Authenticated user attaches file to a new question' do
    visit new_question_path

    fill_in 'Title', with: 'Test title'
    fill_in 'Body', with: 'Test body'

    click_on 'Add file'
    find_field('File').send_keys win_remote_fixture_path 'test_file.txt'

    click_on 'Ask'

    click_on 'Show'

    expect(page).to have_link 'test_file.txt'
  end

  scenario 'Author of a question adds files to it' do
    question
    visit question_path(question)

    within('.question') do
      click_on 'Edit'

      click_on 'Add file'
      find_field('File').send_keys win_remote_fixture_path 'test_file.txt'

      click_on 'Add file'
      within('.new-attachments>div:nth-child(2)') do
        find_field('File').send_keys win_remote_fixture_path 'test_file_2.txt'
      end

      click_on 'Ok'
    end

    wait_for_ajax

    expect(page).to have_link 'test_file.txt'
    expect(page).to have_link 'test_file_2.txt'
  end
end
