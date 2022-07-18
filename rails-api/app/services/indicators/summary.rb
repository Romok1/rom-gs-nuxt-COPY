module Indicators
  # @TODO: Some projects have expected scores and pir_scores but no baseline
  # scores. For now, this class assumes that if there is no baseline score
  # that the baseline score is zero. On indicator import we could attach an
  # error if there are PIR years but no baseline.
  class Summary
    def initialize(indicator_id:, date_range: nil, gef_project_ids: [])
      @indicator_id = indicator_id
      @date_range = date_range
      @gef_project_ids = gef_project_ids
    end

    def call
      if @gef_project_ids.present? && filtered_indicator_scores.present? && indicator_data_within_date_range?
        {
          id: @indicator_id,
          chart_data:,
          percentage_progress:,
          filtered_gef_ids:
        }
      else
        {
          id: @indicator_id,
          chart_data:,
          percentage_progress: [],
          filtered_gef_ids: []
        }
      end
    end

    private

    def chart_data
      Indicators::Charts.new(filtered_indicator_scores, @date_range).call
    end

    def percentage_progress
      Indicators::PercentageProgress.new(filtered_indicator_scores).call
    end

    def indicator_data_within_date_range?
      return true unless @date_range

      filtered_indicator_scores.pluck(:year).max >= @date_range[0] &&
        filtered_indicator_scores.pluck(:year).min <= @date_range[1]
    end

    def projects_date_range
      dates = GEFProjectsTimelineEvent.where(gef_project_id: @gef_project_ids).pluck(:date)

      dates.any? ? (dates.min.year..dates.max.year).to_a : []
    end

    def filtered_gef_ids
      @gef_project_ids.present? ? GEFProject.where(id: @gef_project_ids).pluck(:gef_id) : GEFProject.pluck(:gef_id)
    end

    # Find the data we're going to use in the calculations, in this case the
    # indicator scores for the correct projects in the correct date range.
    def filtered_indicator_scores
      @filtered_indicator_scores ||= begin
        indicator_scores = IndicatorScore.where(indicator_id: @indicator_id)
        indicator_scores = indicator_scores.where(gef_project_id: @gef_project_ids) if @gef_project_ids.present?
        if @date_range
          gef_project_ids_in_date_range = indicator_scores.group(:gef_project_id)
            .having('Max(year) >= ? AND Min(year) <= ?', @date_range[0], @date_range[1])
            .pluck(:gef_project_id)
          indicator_scores = indicator_scores.where(gef_project_id: gef_project_ids_in_date_range)
        end
        indicator_scores
      end
    end
  end
end
