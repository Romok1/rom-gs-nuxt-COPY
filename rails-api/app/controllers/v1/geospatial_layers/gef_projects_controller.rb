module V1
  module GeospatialLayers
    class GEFProjectsController < ApplicationController
      before_action :authenticate_v1_user!
      before_action :set_gef_project, only: [:show]

      def index
        render json: gef_projects.as_json(only: %i[gef_id short_title]), status: :ok
      end

      def show
        indicator = Indicator.find_by(tag: params[:tag])
        indicator_summary = Indicators::Summary.new(
          indicator_id: indicator.id,
          date_range: params[:date_range],
          gef_project_ids: [@gef_project.id]
        ).call

        render json: indicator_summary
      end

      private

      def set_gef_project
        authorize @gef_project = GEFProject.find_by_gef_id(params[:id])
      end

      def gef_projects
        authorize policy_scope(GEFProject).undiscarded
      end
    end
  end
end
