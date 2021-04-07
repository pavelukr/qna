class OmniauthCallbacksController < Devise::OmniauthCallbacksController

  skip_before_action :verify_authenticity_token

  def github
    authenticate_for_all(request.env['omniauth.auth'])
  end

  def twitter
    authenticate_for_all(request.env['omniauth.auth'])
  end

  def create_user_without_email
    email = params[:email]
    provider = params[:provider]
    uid = params[:uid]
    @user = User.find_for_oauth_without_email(email, provider, uid)
  end

  def sign_in_without_email
    @user = User.find(params[:user_id])
    sign_in_and_redirect @user, event: :authentication
    set_flash_message(:notice, :success, kind: @user.authorizations[0].provider)
  end

  private

  def authenticate_for_all(auth)
    @user = User.find_for_oauth(auth)
    if !@user.nil?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: auth.provider) if is_navigational_format?
    else
      render partial: 'form_email', locals: { provider: auth.provider,
                                              uid: auth.uid }
    end
  end
end
