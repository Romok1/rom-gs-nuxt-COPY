# frozen_string_literal: true

module V1
  module Users
    class CurrentUserController < V1::ApplicationController
      respond_to :json

      def show
        render json: { user: current_v1_user }
      end
    end
  end
end
