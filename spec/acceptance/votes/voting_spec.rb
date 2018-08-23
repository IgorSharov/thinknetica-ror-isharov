# frozen_string_literal: true

require_relative '../acceptance_helper.rb'

RSpec.feature 'User votes for/against a question or an answer', '
  In order to change entity\'s rating
  as a user which is not its author
  I want to vote for/against it
', js: true do
  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }

  scenario 'Authenticated user votes for something only once' do
    sign_in create(:user)

    visit question_path(question)

    within('.question>.rating') do
      expect(page).not_to have_content '1'
      expect(page).to have_content '0'

      click_on '+'
      wait_for_ajax

      expect(page).to have_css 'a.disabled_link', text: '-'
      expect(page).not_to have_content '0'
      expect(page).to have_content '1'

      click_on '+'
      wait_for_ajax

      expect(page).not_to have_content '1'
      expect(page).to have_content '0'

      click_on '-'
      wait_for_ajax

      expect(page).to have_css 'a.disabled_link', text: '+'
      expect(page).not_to have_content '0'
      expect(page).to have_content '-1'

      click_on '-'
      wait_for_ajax

      expect(page).not_to have_content '-1'
      expect(page).to have_content '0'
    end

    within('.answer>.rating') do
      expect(page).not_to have_content '1'
      expect(page).to have_content '0'

      click_on '+'
      wait_for_ajax

      expect(page).to have_css 'a.disabled_link', text: '-'
      expect(page).not_to have_content '0'
      expect(page).to have_content '1'

      click_on '+'
      wait_for_ajax

      expect(page).not_to have_content '1'
      expect(page).to have_content '0'

      click_on '-'
      wait_for_ajax

      expect(page).to have_css 'a.disabled_link', text: '+'
      expect(page).not_to have_content '0'
      expect(page).to have_content '-1'

      click_on '-'
      wait_for_ajax

      expect(page).not_to have_content '-1'
      expect(page).to have_content '0'
    end
  end

  scenario 'Author can\'t vote for his questions&answers' do
    sign_in user

    visit question_path(question)

    expect(page).not_to have_link '+'
    expect(page).not_to have_link '-'
  end
end
