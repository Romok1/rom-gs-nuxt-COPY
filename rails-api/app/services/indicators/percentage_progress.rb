module Indicators
  class PercentageProgress
    def initialize(filtered_indicator_scores)
      @filtered_indicator_scores = filtered_indicator_scores
    end

    def call
      generate_percentage_progress_hash

      @percentage_progress
    end

    private

    def generate_percentage_progress_hash
      @percentage_progress = []

      indicator_assessments_grouped_by_gef_id.each do |gef_id, scores|
        assessment_array = scores.map do |score|
          {
            year: score[1],
            type: score[2]
          }
        end

        progress_hash = {
          gef_id:,
          percentage_progress: percentage_progress(assessment_array)
        }

        @percentage_progress << progress_hash
      end
    end

    def indicator_assessments_grouped_by_gef_id
      @filtered_indicator_scores.joins(:gef_project)
        .order(year: :asc)
        .pluck(:year, :value, :assessment_type, :gef_id)
        .group_by do |gef_assessment|
          gef_id_index = 3
          gef_assessment[gef_id_index]
        end
    end

    def percentage_progress(assessments_array)
      pir_scores = assessments_array.filter { |assessment| assessment[:type] == 'pir_year' }

      if pir_scores.any?
        calculate_progress_from_assessment_scores(pir_scores, assessments_array)
      else
        0.0 # No assessment, so no progress.
      end
    end

    def calculate_progress_from_assessment_scores(pir_scores, assessments_array)
      latest_assessment_score = pir_scores.last[:year]
      baseline_score = calculate_baseline_score(assessments_array)
      expected_score = find_expected_score(assessments_array)

      (latest_assessment_score - baseline_score) / (expected_score - baseline_score) * 100
    rescue StandardError
      # Could error if there is no 'expected' data.
      nil
    end

    def find_expected_score(assessments_array)
      # 'Expected' is GEF Core indicator target value for the
      # indicator at the end of the project.
      expected_score_hash = assessments_array.find do |assessment|
        assessment[:type] == 'expected_results'
      end

      expected_score_hash[:year]
    end

    def calculate_baseline_score(assessments_array)
      baseline_assessment_array = assessments_array.find do |assessment|
        assessment[:type] == 'baseline'
      end

      # If there is no baseline we set it to zero, which is wrong but we don't
      # have any data to work with and we've done the same above.
      baseline_assessment_array.present? ? baseline_assessment_array[:year] : 0
    end
  end
end
