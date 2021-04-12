class Api::V1::ProfilesController < ApplicationController
  before_action :doorkeeper_authorize!
  before_action :test_skip

  respond_to :json
  def me
    skip_client_authentication_for_password_grant = true
  end

  def test_skip
    skip_client_authentication_for_password_grant = true
  end
end