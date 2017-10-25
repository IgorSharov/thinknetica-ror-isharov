# frozen_string_literal: true

class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  before_action :log_in, only: %i[github vkontakte]

  def github; end

  def vkontakte; end

  def failure
    redirect_to root_path
  end

  def email_confirm_for_oauth
    auth = OmniAuth::AuthHash.new(
      provider: params[:provider],
      uid: params[:uid],
      info: { email: params[:email] }
    )
    if User.find_and_send_confirmation_email(auth)
      flash[:notice] = 'Confirmation sent.'
    else
      flash[:alert] = 'An error occured.'
    end
    redirect_to root_path
  end

  private

  def log_in
    @user = User.find_or_create_for_auth(request.env['omniauth.auth'])
    render('oauth/oauth_email') && return unless @user
    return unless @user.persisted?
    sign_in_and_redirect @user, event: :authentication
    set_flash_message(:notice, :success, kind: action_name) if is_navigational_format?
  end
end
