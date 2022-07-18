# frozen_string_literal: true

module V1
  module Portfolio
    class DateRangesController < ApplicationController
      before_action :authenticate_v1_user!

      def index
        years = GEFProject.joins(
          :georegions,
          :gef_projects_users,
          :focal_areas,
          :indicator_scores
        ).where(filter_hash).pluck(:year).uniq

        date_range = years.any? ? (years.min..years.max).to_a : []

        render json: date_range
      end

      private

      def filter_hash
        hash = {}
        hash[:indicator_scores] = { indicator_id: params[:indicator_id] } if params[:indicator_id].present?
        hash[:georegions] = { id: params[:georegion_ids] } if params[:georegion_ids].present?
        hash[:gef_projects_users] = { user_ids: params[:user_ids] } if params[:user_ids].present?
        hash[:focal_areas] = { id: params[:focal_area_ids] } if params[:focal_area_ids].present?

        hash
      end
    end
  end
end
