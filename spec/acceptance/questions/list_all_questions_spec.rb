# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'User sees all questions', '
  In order to read all questions
  as a user
  I want to list all questions
' do

  given!(:questions) { create_list(:question, 3) }

  scenario 'User see all questions' do
    visit questions_path

    questions.each do |q|
      expect(page).to have_content q.title
      expect(page).to have_content q.body
    end
  end
end
