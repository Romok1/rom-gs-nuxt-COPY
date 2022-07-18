module V1
  module GeospatialLayers
    class IndicatorsController < ApplicationController
      before_action :authenticate_v1_user!
      before_action :set_gef_project, only: [:index]

      def index
        render json: Mappers::IndicatorTabs.new(@gef_project).call
      end

      private

      def set_gef_project
        @gef_project = authorize GEFProject.find_by_gef_id(params[:gef_project_id])
      end
    end
  end
end
