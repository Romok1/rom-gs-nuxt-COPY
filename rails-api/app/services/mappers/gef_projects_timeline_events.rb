module Mappers
  class GEFProjectsTimelineEvents
    def initialize(gef_project, row_hash)
      @gef_project = gef_project
      @row_hash = row_hash
    end

    def call
      attributes = []
      attributes << pif_approval_date unless pif_approval_date.nil?
      attributes << project_endorsement_date unless project_endorsement_date.nil?
      attributes << project_start_date unless project_start_date.nil?
      attributes << first_installment_date unless first_installment_date.nil?
      attributes << mid_term_review_date unless mid_term_review_date.nil?
      attributes << technical_completion_date unless technical_completion_date.nil?
      attributes << terminal_evaluation_date unless terminal_evaluation_date.nil?
      attributes
    end

    private

    def pif_approval_date
      timeline_event_params(:pif_approval_date, extract_spreadsheet_value(:pif_approval_date))
    end

    def project_endorsement_date
      timeline_event_params(:project_endorsement_date, extract_spreadsheet_value(:project_endorsement_date))
    end

    def project_start_date
      # @TODO: When the "Date of latest signature date on the umbrella legal
      # instrument" is added to the spreadsheet, we should use the max of that
      # at :unep_signature_date.
      timeline_event_params(:project_start_date, extract_spreadsheet_value(:unep_signature_date))
    end

    def first_installment_date
      # @TODO: Add when the first installment date is added to the spreadsheet.
      nil
    end

    def mid_term_review_date
      # @TODO: Add when the mid-term review date is added to the spreadsheet.
      nil
    end

    def technical_completion_date
      # For completion date we only want to show the latest date of the three
      # completion date fields.

      completion_dates = [
        extract_spreadsheet_value(:expected_completion_date)&.to_date,
        extract_spreadsheet_value(:revised_completion_date)&.to_date,
        extract_spreadsheet_value(:actual_completion_date)&.to_date
      ].compact

      completion_date = completion_dates.filter { |date| date.is_a?(Date) }.max

      timeline_event_params(:technical_completion_date, completion_date)
    end

    def terminal_evaluation_date
      # @TODO: Add when the terminal evaluation date is added to the spreadsheet.
      nil
    end

    def timeline_event_params(date_type, date)
      Mappers::TimelineEvent.new(@gef_project, date_type, date).call if date.present?
    end

    def extract_spreadsheet_value(key)
      return nil unless Mappers::GEFProject::EXPECTED_HEADERS.keys.include?(key)

      @row_hash[key]
    end

    def add_error(error)
      @gef_project.errors.add(:base, error)
    end
  end
end
