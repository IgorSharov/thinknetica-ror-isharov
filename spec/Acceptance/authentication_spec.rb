# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'User signs in', '
  In order to ask questions
  as a user
  I want to sign in
' do
  scenario 'Registered user try to sign in' do
    User.create!(email: 'user@test.com', password: '12345')

    visit new_user_session_path

    fill_in 'Email', with: 'user@test.com'
    fill_in 'Password', with: '12345'
    click_on 'Sign in'

    expect(page).to have_content 'Signed in successfully.'
    expect(page).to have_current_path root_path
  end

  scenario 'Unregistered user try to sign in' do
    visit new_user_session_path

    fill_in 'Email', with: 'wrong_user@test.com'
    fill_in 'Password', with: '12345'
    click_on 'Sign in'

    expect(page).to have_content 'Invalid login or password.'
    expect(page).to have_current_path new_user_session_path
  end
end
