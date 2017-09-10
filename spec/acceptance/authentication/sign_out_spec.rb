# frozen_string_literal: true

require_relative '../acceptance_helper.rb'

RSpec.feature 'User signs out', '
  In order to quit
  as an authenticated user
  I want to sign out
' do
  scenario 'Authenticated user signs out' do
    sign_in create(:user)

    click_on 'Log out'

    expect(page).to have_content 'Signed out successfully.'
  end
end
