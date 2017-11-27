# frozen_string_literal: true

module Api
  module V1
    class ProfilesController < ApplicationController
      skip_authorization_check
      before_action :doorkeeper_authorize!

      respond_to :json

      def me
        respond_with current_resource_owner, except: %i[created_at updated_at]
      end

      protected

      def current_resource_owner
        @current_resource_owner ||= User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
      end
    end
  end
end
