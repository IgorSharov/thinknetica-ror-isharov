# frozen_string_literal: true

require 'rails_helper'

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
