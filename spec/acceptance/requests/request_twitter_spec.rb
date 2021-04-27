require_relative '../acceptance_helper'
require 'uri'
require 'net/http'
require 'open-uri'

feature 'Authenticate from soc.network', "
  In order to speed up signing in
  As an soc.network user
  I'd like to authenticate using created account
" do

  before do
    Rails.application.env_config["devise.mapping"] = Devise.mappings[:user] # If using Devise
    Rails.application.env_config["omniauth.auth"] = OmniAuth.config.mock_auth[:twitter]
    visit new_user_session_path
    mock_auth_hash
    clear_emails
  end

  scenario 'User tries to sign in for the first time' do
    click_on 'Sign in with Twitter'
    fill_in 'email', with: 'test@test.com'
    click_on 'Submit'

    open_email('test@test.com')
    current_email.click_button 'Confirm'
    #save_and_open_page
  end

  scenario 'User tries to sign in after registration' do
    @user = create(:user, confirmed: true)
    @user.authorizations.create(provider: 'twitter', uid: '123545')

    click_on 'Sign in with Twitter'

    expect(page).to have_content 'Successfully authenticated from twitter account.'
  end
end
