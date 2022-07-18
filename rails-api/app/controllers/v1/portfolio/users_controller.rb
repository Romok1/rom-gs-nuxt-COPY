# frozen_string_literal: true

module V1
  module Portfolio
    class UsersController < ApplicationController
      before_action :authenticate_v1_user!

      def index
        render json: users
      end

      private

      def users
        return [] if current_v1_user.task_manager?

        policy_scope(GEFProject).undiscarded
          .joins(:users).order('users.name')
          .pluck(:'users.id', :'users.name')
          .uniq
          .map do |id, name|
            { id:, name: }
          end
      end
    end
  end
end
