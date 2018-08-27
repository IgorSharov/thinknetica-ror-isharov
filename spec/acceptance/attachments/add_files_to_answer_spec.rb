# frozen_string_literal: true

require_relative '../acceptance_initializer.rb'

RSpec.feature 'User adds files to an answer', '
  In order to clarify an answer
  as a user
  I want to attach files to an answer
', js: true do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question, user: user) }

  background do
    sign_in user
  end

  scenario 'Authenticated user attaches files to a new answer' do
    visit question_path(question)

    within('.new_answer') do
      fill_in 'Your answer:', with: 'Test Body'

      click_on 'Add file'
      # attach_file 'File', Rails.root.join(file_fixture('test_file.txt'))
      find_field('File').send_keys win_remote_fixture_path 'test_file.txt'

      click_on 'Add answer'
      wait_for_ajax
    end

    expect(page).to have_link 'test_file.txt'
  end

  scenario 'Author of an answer adds files to it' do
    visit question_path(question)

    within('.answer') do
      click_on 'Edit'

      click_on 'Add file'
      find_field('File').send_keys win_remote_fixture_path 'test_file.txt'

      click_on 'Add file'
      within('.new-attachments>div:nth-child(2)') do
        find_field('File').send_keys win_remote_fixture_path 'test_file_2.txt'
      end

      click_on 'Ok'
      wait_for_ajax

      expect(page).to have_link 'test_file.txt'
      expect(page).to have_link 'test_file_2.txt'
    end
  end
end
