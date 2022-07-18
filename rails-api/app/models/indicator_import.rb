class IndicatorImport < ApplicationRecord
  SPREADSHEET_FILENAME = 'GEF BDLD Impact Data V10_Feb08_2022.xlsx'
  SPREADSHEET_TAB_NAME = 'GEF Core Indicators'

  enum status: %i[pending processing completed failed]

  has_many :indicator_import_errors

  after_save :send_error_notification, if: proc { status.in?(%w[failed completed]) && indicator_import_errors.present? }

  def spreadsheet_filename
    SPREADSHEET_FILENAME
  end

  def spreadsheet_tab_name
    SPREADSHEET_TAB_NAME
  end

  def send_error_notification
    ImportErrorMailer.with(import: self).import_errors.deliver_later
  end

  def build_errors(errors)
    indicator_import_errors.build(errors.flatten)
  end

  def destroy_import_errors(gef_project)
    gef_project.indicator_import_errors.destroy_all
  end

  def mapper
    Mappers::Indicator
  end

  def builder
    Builders::Indicators
  end

  def import_errors
    indicator_import_errors
  end

  def self.last_sync
    last
  end
end
