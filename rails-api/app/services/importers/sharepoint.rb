# frozen_string_literal: true

module Importers
  class Sharepoint
    def initialize(
      import,
      sharepoint_file_download_service = ::Sharepoint::FileDownload,
      xlsx_import_service = ::Importers::Xlsx,
      errors = []
    )
      @import = import
      @sharepoint_file_download_service = sharepoint_file_download_service
      @xlsx_import_service = xlsx_import_service
      @errors = errors
    end

    def call
      @import.update(status: :processing)
      sharepoint_xlsx_file_location = @sharepoint_file_download_service.new(@import, @errors).call
      @xlsx_import_service.new(@import, @errors).call
      delete_downloaded_file(sharepoint_xlsx_file_location)
      save_import(:completed)
    rescue StandardError => e
      delete_downloaded_file(sharepoint_xlsx_file_location)
      @errors << { row_number: 1, message: e.message, gef_project_id: nil }
      save_import(:failed)
    end

    def save_import(status)
      @import.build_errors(@errors.flatten)
      @import.status = status
      @import.save!
    end

    def delete_downloaded_file(file_location)
      File.delete(file_location) if file_location && File.exist?(file_location)
    end
  end
end
