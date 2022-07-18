class TimelineEvent < ApplicationRecord
  has_many :gef_projects_timeline_events
  has_many :gef_projects, through: :gef_projects_timeline_events
  validates_presence_of :name
  validates_uniqueness_of :name

  def self.event_name(event_symbol)
    case event_symbol
    when :pif_approval_date
      'PIF Approval Date'
    when :project_endorsement_date
      'Project Endorsement Date'
    when :project_start_date
      'Project Start Date'
    when :first_installment_date
      'First Installment Date'
    when :mid_term_review_date
      'Midterm Review Date'
    when :technical_completion_date
      'Technical Completion Date'
    when :terminal_evaluation_date
      'Terminal Evaluation Date'
    end
  end

  def self.project_start_events
    # GEF Core Indicator Baseline surveys don't have a date in the spreadsheet,
    # so we need to infer one from one of these timeline events.
    [
      event_name(:pif_approval_date),
      event_name(:project_endorsement_date),
      event_name(:project_start_date),
      event_name(:first_installment_date)
    ]
  end

  def self.project_finish_events
    # GEF Core Indicator expected values don't have a date in the spreadsheet,
    # so we need to infer one from one of these timeline events.
    [
      event_name(:technical_completion_date),
      event_name(:terminal_evaluation_date)
    ]
  end
end
