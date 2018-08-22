# frozen_string_literal: true

module AcceptanceHelper
  def sign_in(user)
    visit new_user_session_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_on 'Log in'
  end

  def win_remote_fixture_path(file_name)
    File.join('D:',
              'Development',
              'thinknetica-ror-isharov',
              file_fixture(file_name)).tr!('/', '\\')
  end
end
