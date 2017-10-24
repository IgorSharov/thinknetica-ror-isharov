# frozen_string_literal: true

class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  before_action :log_in, except: :failure

  def github; end

  def vkontakte; end

  def failure
    redirect_to root_path
  end

  private

  def log_in
    @user = User.find_or_create_for_auth(request.env['omniauth.auth'])
    return unless @user.persisted?
    sign_in_and_redirect @user, event: :authentication
    set_flash_message(:notice, :success, kind: action_name) if is_navigational_format?
  end
end
