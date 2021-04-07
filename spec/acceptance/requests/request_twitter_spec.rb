require_relative '../acceptance_helper'

describe "GET '/auth/twitter/callback'" do

  before(:each) do
    mock_auth_hash
    get "auth/twitter/callback"
    request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:twitter]
  end

  it "should set user_id" do
    expect(session[:user_id]).to eq(User.last.id)
  end

  it "should redirect to root" do
    expect(response).to redirect_to root_path
  end
end

describe "GET '/auth/twitter/callback'" do

  describe 'access top page' do

    it 'should set user_id' do
      mock_auth_hash
      get 'auth/twitter/callback'
      request.env['omniauth.auth'] = OmniAuth.config.mock_auth[:twitter]

      expect(session[:user_id]).to eq(User.last.id)
    end

    it 'should redirect to root' do
      expect(response).to redirect_to root_path
    end

    it 'can handle authentication error' do
      OmniAuth.config.mock_auth[:twitter] = :invalid_credentials
      visit '/users/sign_in'
      page.should have_content('Sign in with Twitter')
      click_link 'Sign in with Twitter'
      page.should have_content('Could not authenticate you from Twitter because "Invalid credentials".')
    end

  end
end
