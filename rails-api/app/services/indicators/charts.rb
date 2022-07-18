module Indicators
  # For now, this class assumes that if there is no baseline score that the
  # baseline score is zero. On indicator import we could attach an error if
  # there are PIR years but no baseline.
  #
  # @TODO: Some projects have expected scores & pir_scores but no baseline.
  class Charts
    def initialize(filtered_indicator_scores, date_range = [])
      @filtered_indicator_scores = filtered_indicator_scores
      @date_range = date_range
    end

    def call
      if @filtered_indicator_scores.any?
        {
          years: year_range,
          expected: expected_sum,
          projects_assessed: data_year_range.present? ? projects_assessed : [],
          indicator_values: data_year_range.present? ? indicator_values : []
        }
      else
        {
          years: [],
          expected: nil,
          projects_assessed: [],
          indicator_values: []
        }
      end
    end

    private

    # PIR Years are the 'mid-term' assessments of GEF core indicators
    def assessments
      @filtered_indicator_scores.where(assessment_type: 'pir_year')
    end

    # The full range including expected, pir, and baseline years. Used to set the
    # range of the x-axis. If no date range is provided, the date range of the
    # project data is used. if a date range argument is provided we use the date
    # range argument end as the end of the range, but the start of the range is
    # the beginning of the available project data, because we need it for
    # interpolating missing years.
    def year_range
      @year_range ||= if @date_range.present?
                        Utils.range(@dange_range)
                      else
                        years = @filtered_indicator_scores.pluck(:year).uniq.compact.map(&:to_i)
                        Utils.range(years)
                      end
    end

    def data_year_range
      # The year range for which we have data, either from baseline or pir asessments
      @data_year_range ||= begin
        years = @filtered_indicator_scores.where.not(assessment_type: 'expected_results')
          .pluck(:year).uniq.compact.map(&:to_i)
        years.present? ? Utils.range(years) : []
      end
    end

    def projects_assessed
      # Missing years for projects, so we need to know not only which projects
      # were assessed in each year, but also which projects were assessed in
      # previous years.

      gef_project_id_first_assessment_year_arrays = assessments.group(:gef_project_id).minimum(:year).sort

      # Build a hash to store gef_project_ids under the year when they are first
      # assessed. E.g. { 2020 => [id_1, id_2] }
      year_to_gef_project_id_hash = {}

      data_year_range.each do |year|
        year_to_gef_project_id_hash[year] = []
      end

      # Add the gef_project_id to the year_to_gef_project_id_hash.
      gef_project_id_first_assessment_year_arrays.each do |gef_project_id_first_assessment_year_array|
        year = gef_project_id_first_assessment_year_array[1]
        gef_project_id = gef_project_id_first_assessment_year_array[0]

        year_to_gef_project_id_hash[year] << gef_project_id
      end

      # Each year is the gef_project_ids for that year plus any following years.
      starting_position = 1 # because the RHS depends on -1 reference in array index

      data_year_range[starting_position..].each do |year|
        gef_project_ids_for_year = begin
          current_year_ids = year_to_gef_project_id_hash[year]
          previous_years_ids = year_to_gef_project_id_hash[year - starting_position]
          all_ids = current_year_ids + previous_years_ids

          all_ids.uniq
        end

        year_to_gef_project_id_hash[year] = gef_project_ids_for_year
      end

      projects_assessed_count_array = year_to_gef_project_id_hash.map { |_year, gef_project_ids| gef_project_ids.count }

      # If we have a date_range, we need to extract only
      # the years that correspond with the range
      @date_range.present? ? slice_by_date_range(projects_assessed_count_array) : projects_assessed_count_array
    end

    def expected_sum
      @filtered_indicator_scores.where(assessment_type: 'expected_results').sum(:value)
    end

    # Produces an array of indicator values, the positions of which match the
    # years in data_year_range. Because each project has missing years, we need
    # to fill in the missing array positions with the previous year's value.
    def indicator_values
      two_dimensional_array = []

      # Iterate over the projects to build an array of indicator values with
      # positions that correspond to the data_year_range array. Because we don't
      # have an assessment every year, we need to fill in blank years with the
      # most recent known value.
      filtered_indicator_scores_grouped_by_gef_project_id.each do |_gef_project_id, indicator_assessments|
        # If there is no baseline we set it to zero, which is wrong but we
        # don't have any data to work with.
        baseline_assessment = indicator_assessments.find { |score| score[:assessment_type] == 'baseline' }
        baseline_value = baseline_assessment.present? ? baseline_assessment[:value] : 0

        # The baseline value is the first position in the array which
        # corresponds to the first year in the data_year_range.
        indicator_value_array = [baseline_value]

        # Build hash with assessment year keys & indicator values.
        assessment_value_hash = {}
        indicator_assessments.each { |score| assessment_value_hash[score[:year]] = score[:value] }

        # For each position in the data_year_range array create a corresponding
        # position in the indicator_value_array that is either the assessment
        # value for that year if there was an assessment, or the previous year
        # if there wasn't an assessment.
        data_year_range[1..].each do |year|
          indicator_value_array << (assessment_value_hash[year] || indicator_value_array.last)
        end
        two_dimensional_array << indicator_value_array
      end

      # The two_dimensional array now contains an array of the same length for
      # each project. We need to sum across the arrays at each position to give
      # a total value of the indicator for each year.
      indicator_array = two_dimensional_array.transpose.map { |a| a.inject(:+) }

      # If we have a date_range, we need to extract only the years that
      # correspond with the range.
      @date_range.present? ? slice_by_date_range(indicator_array) : indicator_array
    end

    def slice_by_date_range(array)
      # We are calculating years prior to any date range because chart data is
      # dependent on earlier years so here we need to slice the array to match
      # the requested @date_range.
      @start_index ||= @date_range[0] - data_year_range[0]
      @end_index ||= @start_index + @date_range[1] - @date_range[0]

      if @start_index >= 0
        array[@start_index..@end_index]
      else
        # @data_range begins before the start of the indicator data,
        # so we need to prepend nil values.
        ([nil] * (@start_index.magnitude - 1)) + array[0..@end_index]
      end
    end

    def filtered_indicator_scores_grouped_by_gef_project_id
      @filtered_indicator_scores
        .where.not(assessment_type: 'expected_results')
        .order(assessment_type: :desc)
        .pluck(:year, :value, :assessment_type, :gef_project_id)
        .map do |filtered_indicator_score|
          {
            year: filtered_indicator_score[0],
            value: filtered_indicator_score[1],
            assessment_type: filtered_indicator_score[2],
            gef_project_id: filtered_indicator_score[3]
          }
        end
        .group_by do |gef_assessment|
          gef_assessment[:gef_project_id]
        end
    end
  end
end
