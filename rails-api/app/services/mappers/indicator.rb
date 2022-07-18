# frozen_string_literal: true

module Mappers
  class Indicator
    EXPECTED_HEADERS = {
      gef_id: 'GEF ID',
      title: 'Project title',
      timeline: 'Timeline',
      pir_year: 'PIR Year',
      core_indicator: 'Core Indicators',
      core_indicator_value: 'Core Indicators Value',
      sub_indicator: 'Sub-core indicator',
      sub_indicator_value: 'Sub core-indicator value',
      unit: 'Unit_of Measure'
    }.freeze

    def initialize(gef_project, row_hash)
      @gef_project = gef_project
      @row_hash = row_hash
    end

    def expected_headers
      EXPECTED_HEADERS
    end

    def call
      if indicator_name_present? && has_year?
        {
          indicator_scores_attributes: [
            {
              id: indicator_score_id,
              indicator_id:,
              value: indicator_value,
              year:,
              assessment_type:
            }
          ]
        }
      else
        add_error(I18n.t('imports.import_errors.indicator.indicator_names_missing')) unless indicator_name_present?
        unless has_year? || spreadsheet_value(:timeline).blank?
          add_error(I18n.t('imports.import_errors.indicator.year_missing'))
        end
        {}
      end
    end

    def indicator_name_present?
      spreadsheet_value(:sub_indicator).present? || spreadsheet_value(:core_indicator).present?
    end

    def has_year?
      year.present?
    end

    def indicator_score_id
      IndicatorScore.find_by(gef_project_id: @gef_project.id, indicator_id:,
        assessment_type:, year:)&.id
    end

    def indicator_value
      if spreadsheet_value(:core_indicator_value).present? && spreadsheet_value(:sub_indicator_value).present?
        add_error(I18n.t('imports.import_errors.indicator.core_and_subindicator_values_present'))
        nil
      elsif spreadsheet_value(:core_indicator_value).present?
        spreadsheet_value(:core_indicator_value)
      elsif spreadsheet_value(:sub_indicator_value).present?
        spreadsheet_value(:sub_indicator_value)
      else
        add_error(I18n.t('imports.import_errors.indicator.value_missing'))
        nil
      end
    end

    def spreadsheet_value(key)
      cell_value = @row_hash[key]
      cell_value.is_a?(String) ? cell_value.strip : cell_value
    end

    def find_indicator(indicator_name)
      indicator = ::Indicator.find_by_name(indicator_name)
      return indicator if indicator

      # Try to find the indicator by the code.
      indicator_code = indicator_name.split(':')[0]
      ::Indicator.where('name ILIKE ?', "%#{indicator_code}:%").first # include colon to prevent finding sub-indicators
    rescue StandardError
      nil
    end

    def indicator_id
      @indicator_id ||= begin
        indicator = find_or_create_indicator

        indicator.id
      end
    end

    def find_or_create_indicator
      parent_indicator = find_indicator(spreadsheet_value(:core_indicator)) || ::Indicator.create(
        name: spreadsheet_value(:core_indicator), indicator_type:
      )

      if spreadsheet_value(:sub_indicator).blank?
        parent_indicator
      else
        find_indicator(spreadsheet_value(:sub_indicator)) || ::Indicator.create(
          name: spreadsheet_value(:sub_indicator), indicator_type:, parent_id: parent_indicator.id
        )

      end
    end

    def indicator_type
      @_indicator_type ||= IndicatorType.find_by_name('GEF Core Indicator')
    end

    def year
      @_year ||= if spreadsheet_value(:pir_year).present?
                   spreadsheet_value(:pir_year)
                 else
                   spreadsheet_value(:timeline) == 'Baseline' ? baseline_date&.year : completion_date&.year
                 end
    end

    def baseline_date
      # Baseline assessments don't have a year attached to them, so we need to
      # get one from the dates stored in the project's timeline_events. We use 
      # this for filtering date ranges for indicator summaries
      @baseline_date ||= @gef_project.gef_projects_timeline_events
        .joins(:timeline_event)
        .where('timeline_events.name': [
          ::TimelineEvent.event_name(:pif_approval_date),
          ::TimelineEvent.event_name(:project_endorsement_date),
          ::TimelineEvent.event_name(:project_start_date),
          ::TimelineEvent.event_name(:first_installment_date)])
        .order('gef_projects_timeline_events.date ASC')
        .pluck(:date)&.first
    end

    def completion_date
      # Expected indicator values don't have a year attached to them, so we need
      # to get one from the dates stored in the project's timeline_events. We
      # use this for filtering date ranges for indicator summaries
      @completion_date ||= begin
        dates = {}
        @gef_project.gef_projects_timeline_events
          .joins(:timeline_event)
          .where('timeline_events.name': [
            ::TimelineEvent.event_name(:technical_completion_date),
            ::TimelineEvent.event_name(:terminal_evaluation_date)
          ])
          .order('gef_projects_timeline_events.date ASC')
          .select('timeline_events.name AS name')
          .pluck(:date)&.last
      end
    end

    def assessment_type
      spreadsheet_value(:timeline).downcase.gsub(' ', '_')
    end

    def add_error(error)
      @gef_project.errors.add(:base, error)
    end
  end
end
