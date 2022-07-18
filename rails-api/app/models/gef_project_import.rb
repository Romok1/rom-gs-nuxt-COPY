# frozen_string_literal: true

class GEFProjectImport < ApplicationRecord
  SPREADSHEET_FILENAME = 'BDLD GEF Unit Projects.xlsx'
  SPREADSHEET_TAB_NAME = 'UNEP GEF Projects'

  enum status: %i[pending processing completed failed]

  has_many :gef_project_import_errors

  after_save :send_error_notification, if: proc {
                                             status.in?(%w[failed completed]) && gef_project_import_errors.present?
                                           }

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
    gef_project_import_errors.build(errors.flatten)
  end

  def builder
    Builders::GEFProjects
  end

  def mapper
    Mappers::GEFProject
  end

  def import_errors
    gef_project_import_errors
  end

  def self.last_sync
    last
  end
end
