# frozen_string_literal: true

require_relative '../acceptance_helper.rb'

RSpec.feature 'Author of a question marks an answer as the best one', '
  In order to set an answer as the best one
  as an author of question
  I want to mark an answer as the best one
' do
  scenario 'Author of a question marks the only answer as the best one'
  scenario 'The best answer is put the first'
  scenario 'User can\'t mark an answer for another\'s question'
  scenario 'Non-Authenticated user can\'t mark any answer'
end
