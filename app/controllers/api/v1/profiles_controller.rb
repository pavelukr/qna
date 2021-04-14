module Api
  module V1
    class ProfilesController < Api::BaseController

      def index
        respond_with list_of_users
      end

      def me
        respond_with current_resource_owner
      end

      protected

      def list_of_users
        @list_of_users ||= (User.where.not(id: doorkeeper_token.resource_owner_id) if doorkeeper_token)
      end
    end
  end
end
