# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'User edits his answer', '
  In order to clarify my answer
  as a user
  I want to edit my answer in the system
' do
  scenario 'Author edits his answer'
  scenario 'User can\'t edit another\'s answer'
  scenario 'Non-Authenticated user can\'t edit any answer'
end
