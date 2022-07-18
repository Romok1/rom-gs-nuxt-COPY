module V1
  module Geoserver
    class ShapefilesController < ApplicationController
      # Controller only to be used by Geoserver to update the status
      # of a shapefile after we upload it.

      # No authentication on this endpoint.
      # @TODO: make sure this access is prevented execept for geoserver.
      # Has been discussed with Stuart.

      before_action :set_shapefile

      def update
        if @shapefile.update(shapefile_params)
          render json: @shapefile, status: :ok
        else
          render json: @shapefile.errors, status: :unprocessable_entity
        end
      rescue StandardError => e
        render json: e.message, status: :unprocessable_entity
      end

      private

      def set_shapefile
        @shapefile = GEFProject.find_by_gef_id(params[:id]).shapefile
      end

      def shapefile_params
        params.require(:shapefile).permit(
          :status,
          shapefile_import_errors_attributes: [:message]
        )
      end
    end
  end
end
