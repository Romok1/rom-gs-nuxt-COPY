# frozen_string_literal: true

module V1
  module Portfolio
    class GeoregionsController < ApplicationController
      before_action :authenticate_v1_user!

      def index
        gef_projects = policy_scope(GEFProject).undiscarded
        georegions = gef_projects.joins(:georegions).order('georegions.id')
          .pluck(:'georegions.id', :'georegions.name')
          .uniq
          .map do |id, name|
            { id:, name: }
          end

        render json: georegions
      end
    end
  end
end
