# frozen_string_literal: true

module Mappers
  class ImportErrors
    def initialize(gef_project)
      @gef_project = gef_project
    end

    def call
      import_errors = []
      import_errors << gef_project_import_errors if gef_project_import_errors
      import_errors << indicator_import_errors if indicator_import_errors
      import_errors << shapefile_upload_errors if shapefile_upload_errors
      import_errors
    end

    private

    def gef_project_import_errors
      @gef_project_import_errors ||= begin
        errors = @gef_project.gef_project_import_errors

        if errors.present?
          errors_object(errors,
            "#{GEFProjectImport::SPREADSHEET_FILENAME} - #{GEFProjectImport::SPREADSHEET_TAB_NAME}")
        end
      end
    end

    def indicator_import_errors
      @indicator_import_errors ||= begin
        errors = @gef_project.indicator_import_errors

        if errors.present?
          errors_object(errors,
            "#{IndicatorImport::SPREADSHEET_FILENAME} - #{IndicatorImport::SPREADSHEET_TAB_NAME}")
        end
      end
    end

    def shapefile_upload_errors
      @shapefile_upload_errors ||= begin
        errors = @gef_project.shapefile&.shapefile_import_errors

        errors_object(errors, 'Shapefile Upload') if errors.present?
      end
    end

    def errors_object(errors, data_source)
      {
        data_source:,
        errors: errors.as_json(only: %i[row_number message])
      }
    end
  end
end
