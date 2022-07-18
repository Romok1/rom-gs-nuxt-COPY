# frozen_string_literal: true

module Mappers
  class IndicatorTabs
    def initialize(gef_project)
      @gef_project = gef_project
    end

    def call
      [
        {
          tab_header: 'GEF Core Indicators',
          categories: gef_core_indicators
        },
        {
          tab_header: 'Core Areas',
          categories: focal_areas
        }
      ]
    end

    def gef_core_indicators
      @gef_project.indicators.as_json(only: %i[name tag])
    end

    def focal_areas
      @gef_project.focal_areas.as_json(only: %i[name tag])
    end
  end
end
