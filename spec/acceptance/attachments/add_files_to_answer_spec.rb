# frozen_string_literal: true

require_relative '../acceptance_helper.rb'

RSpec.feature 'User adds files to an answer', '
  In order to clarify an answer
  as a user
  I want to attach files to an answer
' do
  given(:user) { create(:user) }
  given!(:question) { create(:question) }
  given(:answer) { create(:answer, question: question, user: user) }

  background do
    sign_in user
  end

  scenario 'Authenticated user attaches files to a new answer' do
    visit question_path(question)

    within('.new_answer') do
      fill_in 'Your answer:', with: 'Test Body'

      click_on 'Add file'
      attach_file 'File', file_fixture('test_file.txt')

      click_on 'Add file'
      attach_file 'File', file_fixture('test_file_2.txt')

      click_on 'Add answer'

      expect(page).to have_content 'test_file.txt'
      expect(page).to have_content 'test_file_2.txt'
    end
  end

  scenario 'Author of an answer adds files to it' do
    visit question_path(question)

    within('.answer') do
      click_on 'Add file'

      fill_in 'Your answer:', with: 'Test Body'

      click_on 'Add file'
      attach_file 'File', file_fixture('test_file.txt')

      click_on 'Add file'
      attach_file 'File', file_fixture('test_file_2.txt')

      click_on 'Add answer'

      expect(page).to have_content 'test_file.txt'
      expect(page).to have_content 'test_file_2.txt'
    end
  end
end
