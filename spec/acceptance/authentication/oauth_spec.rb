# frozen_string_literal: true

require_relative '../acceptance_initializer.rb'

RSpec.feature 'User sings in with OAuth', '
  In order to sign in
  as a user of an outer social network
  I want to authorize via my social network account
' do
  background do
    visit new_user_session_path
  end

  context 'email is provided' do
    background do
      mock_auth_hash
    end

    scenario 'User signs in via Vkontakte' do
      click_on 'Sign in with Vkontakte'

      expect(page).to have_content 'Successfully authenticated from vkontakte account.'
      expect(page).to have_current_path root_path
    end

    scenario 'User signs in via Github' do
      click_on 'Sign in with GitHub'

      expect(page).to have_content 'Successfully authenticated from github account.'
      expect(page).to have_current_path root_path
    end
  end

  context 'email is not provided' do
    background do
      clear_emails
      mock_auth_hash_without_email
    end

    scenario 'User signs in via Vkontakte' do
      click_on 'Sign in with Vkontakte'

      expect(page).to have_content 'Please enter your email for confirmation'

      email = 'example@email.com'

      fill_in 'Email:', with: email
      click_on 'Send confirmation'

      expect(page).to have_content 'Confirmation sent.'
      expect(page).to have_current_path root_path

      visit new_user_session_path
      click_on 'Sign in with Vkontakte'

      expect(page).to have_content 'You have to confirm your email address before continuing.'

      open_email(email)

      expect(current_email).to have_content email

      current_email.click_on 'Confirm my account'

      click_on 'Sign in with Vkontakte'

      expect(page).to have_content 'Successfully authenticated from vkontakte account.'
      expect(page).to have_current_path root_path
    end

    scenario 'User signs in via Github' do
      click_on 'Sign in with GitHub'

      expect(page).to have_content 'Please enter your email for confirmation'

      email = 'example@email.com'

      fill_in 'Email:', with: email
      click_on 'Send confirmation'

      expect(page).to have_content 'Confirmation sent.'
      expect(page).to have_current_path root_path

      visit new_user_session_path
      click_on 'Sign in with GitHub'

      expect(page).to have_content 'You have to confirm your email address before continuing.'

      open_email(email)

      expect(current_email).to have_content email

      current_email.click_on 'Confirm my account'

      click_on 'Sign in with GitHub'

      expect(page).to have_content 'Successfully authenticated from github account.'
      expect(page).to have_current_path root_path
    end
  end
end
