# frozen_string_literal: true

module OmniauthMacros
  def mock_auth_hash
    # The mock_auth configuration allows you to set per-provider (or default)
    # authentication hashes to return during integration testing.
    OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new(provider: 'github', uid: '123545', info: { email: 'mock_user_gh@example.lo' })
    OmniAuth.config.mock_auth[:vkontakte] = OmniAuth::AuthHash.new(provider: 'vkontakte', uid: '54321', info: { email: 'mock_user_vk@example.lo' })
  end

  def mock_auth_hash_without_email
    # The mock_auth configuration allows you to set per-provider (or default)
    # authentication hashes to return during integration testing.
    OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new(provider: 'github', uid: '123545')
    OmniAuth.config.mock_auth[:vkontakte] = OmniAuth::AuthHash.new(provider: 'vkontakte', uid: '54321')
  end
end
