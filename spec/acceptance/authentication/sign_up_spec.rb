# frozen_string_literal: true

require_relative '../acceptance_initializer.rb'

RSpec.feature 'Unregistered user signs up', '
  In order to sign up
  as an unregistered user
  I want to create a new user account
' do
  scenario 'Unregistered user creates a new user account' do
    visit new_user_registration_path

    email = 'new_user@test.com'

    fill_in 'Email', with: email
    fill_in '* Password', with: '12345678'
    fill_in '* Password confirmation', with: '12345678'
    click_button 'Sign up'

    expect(page).to have_content 'A message with a confirmation link has been sent to your email address.'
  end
end
