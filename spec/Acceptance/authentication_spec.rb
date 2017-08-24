# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'User signs in', '
  In order to ask questions
  as a user
  I want to sign in
' do
  scenario 'Registered user try to sign in' do
    User.create!(email: 'user@test.com', password: '123456')

    visit new_user_session_path

    fill_in 'Email', with: 'user@test.com'
    fill_in 'Password', with: '123456'
    click_on 'Log in'

    expect(page).to have_content 'Signed in successfully.'
    expect(page).to have_current_path root_path
  end

  scenario 'Unregistered user try to sign in' do
    visit new_user_session_path

    fill_in 'Email', with: 'wrong_user@test.com'
    fill_in 'Password', with: '123456'
    click_on 'Log in'

    expect(page).to have_content 'Invalid Email or password.'
    expect(page).to have_current_path new_user_session_path
  end
end

RSpec.feature 'Unregistered user can sign up', '
  In order to sign up
  as an unregistered user
  I want to create a new user account
' do
  scenario 'Unregistered user creates a new user account' do
    visit new_user_registration_path

    email = 'new_user@test.com'

    fill_in 'Email', with: email
    fill_in 'Password', with: '12345678'
    fill_in 'Password confirmation', with: '12345678'
    click_button 'Sign up'

    expect(page).to have_content 'Welcome! You have signed up successfully.'
  end
end
