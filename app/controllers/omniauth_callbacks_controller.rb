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
      provider: session[:provider],
      uid: session[:uid],
      info: { email: params[:email] }
    )
    if User.find_and_send_confirmation_email(auth)
      flash[:notice] = 'Confirmation sent.'
    else
      flash[:alert] = 'An error occured.'
    end
    session[:provider] = nil
    session[:uid] = nil
    redirect_to root_path
  end

  private

  def log_in
    @user = User.find_or_create_for_auth(request.env['omniauth.auth'])
    unless @user
      session[:provider] = request.env['omniauth.auth'].provider
      session[:uid] = request.env['omniauth.auth'].uid.to_s
      render('oauth/oauth_email')
      return
    end
    return unless @user.persisted?
    sign_in_and_redirect @user, event: :authentication
    set_flash_message(:notice, :success, kind: action_name) if is_navigational_format?
  end
end
