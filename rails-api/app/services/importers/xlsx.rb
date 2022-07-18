# frozen_string_literal: true

class Importers::Xlsx
  def initialize(
    import,
    errors,
    header_converter = Mappers::HeaderConverter
  )
    @import = import
    @errors = errors
    @header_converter = header_converter
  end

  def call
    extract_tab_from_xlsx
    header_dictionary = build_header_dictionary
    validate_headers(header_dictionary)
    import_rows(header_dictionary) if @errors.empty?
  rescue StandardError => e
    add_error(1, e)
  end

  private

  def extract_tab_from_xlsx
    spreadsheet = Roo::Excelx.new(
      "#{Rails.application.credentials.sharepoint.download_directory}#{@import.spreadsheet_filename}"
    )
    @spreadsheet_tab = spreadsheet.sheet(@import.spreadsheet_tab_name)
  end

  def build_header_dictionary
    headers = @spreadsheet_tab.row(1)
    @header_converter.build_dictionary(headers, @import.mapper::EXPECTED_HEADERS)
  end

  def validate_headers(header_dictionary)
    return unless header_dictionary.keys.count != @import.mapper::EXPECTED_HEADERS.count

    (@import.mapper::EXPECTED_HEADERS.keys - header_dictionary.keys).each do |missing_expected_header|
      add_error(1,
        I18n.t('imports.import_errors.headers.column_header_not_found',
          expected_header: missing_expected_header))
    end
  end

  def import_rows(header_dictionary)
    rows = []
    row_number = 0
    header_row_number = 1
    @spreadsheet_tab.each(header_dictionary) do |hash|
      row_number += 1

      next if row_number == header_row_number

      rows << { row_number:, row_hash: hash }
    end

    rows.group_by { |row| row[:row_hash][:gef_id] }.each do |gef_id, rows|
      if gef_id
        @import.builder.new(gef_id, rows, @errors).call
      else
        rows.each do |row|
          add_error(row[:row_number],
            I18n.t('imports.import_errors.missing_gef_id'))
        end
      end
    end
  end

  def add_error(row_number, message, gef_project_id = nil)
    @errors << { row_number:, message:, gef_project_id: }
  end
end
