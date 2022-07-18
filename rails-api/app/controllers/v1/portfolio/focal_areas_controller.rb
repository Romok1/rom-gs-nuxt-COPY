# frozen_string_literal: true

module V1
  module Portfolio
    class FocalAreasController < ApplicationController
      before_action :authenticate_v1_user!

      def index
        gef_projects = policy_scope(GEFProject).undiscarded
        focal_areas = gef_projects.joins(:focal_areas).order('focal_areas.name')
          .pluck(:'focal_areas.id', :'focal_areas.name')
          .uniq
          .map do |id, name|
            { id:, name: }
          end

        render json: focal_areas
      end
    end
  end
end
