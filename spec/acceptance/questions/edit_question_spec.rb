# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'User edits his question', '
  In order to clarify my question
  as a user
  I want to edit my question in the system
' do
  scenario 'Author edits his question'
  scenario 'User can\'t edit another\'s question'
  scenario 'Non-Authenticated user can\'t edit any question'
end
