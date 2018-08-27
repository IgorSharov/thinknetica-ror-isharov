# frozen_string_literal: true

require_relative '../acceptance_initializer.rb'

RSpec.feature 'User signs in', '
  In order to ask questions
  as a user
  I want to sign in
' do
  scenario 'Registered user try to sign in' do
    sign_in create(:user)

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
