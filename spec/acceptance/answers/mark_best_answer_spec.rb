# frozen_string_literal: true

require_relative '../acceptance_helper.rb'

RSpec.feature 'Author of a question marks an answer as the best one', '
  In order to set an answer as the best one
  as an author of question
  I want to mark an answer as the best one
', js: true do
  given!(:user) { create(:user) }
  given!(:question) { create(:question_with_answers, user: user) }

  scenario 'Author of a question marks/unmarks the only answer as the best one' do
    sign_in user

    visit question_path(question)

    expect(page).not_to have_css('.best-answer')

    within('.answers>div:nth-child(2)') do
      click_on 'Mark'
      wait_for_ajax
    end

    within('.best-answer') do
      expect(page).to have_content question.answers[0].body
    end

    within('.answers>div:nth-child(4)') do
      click_on 'Mark'
      wait_for_ajax
    end

    within('.best-answer') do
      expect(page).not_to have_content question.answers[0].body
      expect(page).to have_content question.answers[2].body

      click_on 'Unmark'
      wait_for_ajax

      expect(page).not_to have_content question.answers[2].body
    end
  end

  scenario 'The best answer is put the first' do
    sign_in user

    visit question_path(question)

    within('.answers>div:nth-child(4)') do
      click_on 'Mark'
    end

    regex = Regexp.new "#{question.answers[2].body}.*#{question.answers[0].body}"
    expect(page.text).to match(regex)
  end

  scenario 'User can\'t mark an answer for another\'s question' do
    sign_in create(:user)

    visit question_path(question)

    expect(page).not_to have_css('.answer_mark-as-best')
  end

  scenario 'Non-Authenticated user can\'t mark any answer' do
    visit question_path(question)

    expect(page).not_to have_css('.answer_mark-as-best')
  end
end
