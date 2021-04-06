class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def github
    @user = User.find_for_oauth(request.env['omniauth.auth'])
    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: 'GitHub') if is_navigational_format?
    end
  end

  def gitlab
    @user = User.find_for_oauth(request.env['omniauth.auth'])
    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: 'GitLab') if is_navigational_format?
    end
  end

  def twitter
    auth = request.env['omniauth.auth']
    authorization = Authorization.where(provider: auth.provider, uid: auth.uid.to_s).first
    if authorization
      @user = authorization.user
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: 'Twitter') if is_navigational_format?
    else
      render partial: 'form_twitter', locals: { uid: request.env['omniauth.auth'].uid }
    end
  end

    def sign_in_twitter
    email = params[:email]
    provider = params[:provider]
    uid = params[:uid]
    @user = User.find_for_oauth_twitter(email, provider, uid)
    sign_in_and_redirect @user, event: :authentication
    set_flash_message(:notice, :success, kind: 'Twitter') if is_navigational_format?
  end
end
