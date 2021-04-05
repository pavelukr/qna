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
    @user = User.new
    if !request.env['omniauth.auth'].info[:email]
      render 'twitter'
    end
    render json: request.env['omniauth.auth']
  end
end
