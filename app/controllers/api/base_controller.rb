module Api
  class BaseController < ApplicationController
    before_action :doorkeeper_authorize!, unless: :user_signed_in?

    respond_to :json

    def pundit_user
      current_resource_owner
    end

    protected

    def current_resource_owner
      @current_resource_owner ||= (User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token)
    end
  end
end
