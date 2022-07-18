# frozen_string_literal: true

module V1
  class ChartsController < ApplicationController
    before_action :authenticate_v1_user!

    def show
      gef_projects = policy_scope(GEFProject).eager_load(:georegions, :gef_projects_users,
        :focal_areas).where(filter_hash)

      gef_project_ids = gef_projects.pluck(:id).uniq
      gef_ids = gef_projects.pluck(:gef_id).uniq

      # calculate chart data for indicator
      indicator_summary = Indicators::Summary.new(
        indicator_id: params[:id],
        date_range: params[:date_range],
        gef_project_ids:
      ).call

      geojson = ::Geoserver::Geojson.new(gef_ids, :point).call
      geojson_polygons = ::Geoserver::Geojson.new(gef_ids, :polygon).call

      render json: {
        indicator_summary:,
        geojson:,
        geojson_polygons:
      }.as_json
    end

    private

    def filter_hash
      hash = {}
      hash[:georegions] = { id: params[:georegion_ids] } if params[:georegion_ids].present?
      hash[:gef_projects_users] = { user_ids: params[:user_ids] } if params[:user_ids].present?
      hash[:focal_areas] = { id: params[:focal_area_ids] } if params[:focal_area_ids].present?

      hash
    end
  end
end
