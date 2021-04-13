module Api
  module V1
    class ProfilesController < ApplicationController
      before_action :doorkeeper_authorize!, unless: :user_signed_in?

      respond_to :json

      def index
        respond_with list_of_users
      end

      def me
        respond_with current_resource_owner
      end

      protected

      def current_resource_owner
        @current_resource_owner ||= (User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token)
      end

      def list_of_users
        @list_of_users ||= (User.where.not(id: doorkeeper_token.resource_owner_id) if doorkeeper_token)
      end
    end
  end
end
