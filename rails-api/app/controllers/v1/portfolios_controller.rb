# frozen_string_literal: true

module V1
  class PortfoliosController < ApplicationController
    before_action :authenticate_v1_user!

    # GET /portfolios
    def index
      authorize(GEFProject)
      @gef_projects = policy_scope(GEFProject).undiscarded
      gef_ids_as_json = @gef_projects.pluck(:gef_id)

      indicator_types = IndicatorType.all

      indicator_types_as_json = indicator_types.map do |indicator_type|
        {
          id: indicator_type.id,
          name: indicator_type.name
        }
      end
      indicators_as_json = Indicator.roots.map do |indicator|
        {
          id: indicator.id,
          name: indicator.name,
          indicator_type_id: indicator.indicator_type_id
        }
      end

      render json: {
        gef_ids: gef_ids_as_json,
        indicator_types: indicator_types_as_json,
        indicators: indicators_as_json
      }
    end
  end
end
