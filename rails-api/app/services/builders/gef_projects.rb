# frozen_string_literal: true

module Builders
  class GEFProjects
    STATUSES_TO_BE_IMPORTED = ['Under Implementation', 'Technically Completed', 'Completed']

    def initialize(gef_id, rows, errors, mapper = Mappers::GEFProject)
      @gef_id = gef_id
      @rows = rows
      @errors = errors
      @mapper = mapper
    end

    def call
      validate_only_one_row
      return unless status_should_be_imported

      # clear import errors from previous imports
      gef_project.gef_project_import_errors.destroy_all
      update_gef_project_from_rows(gef_project)
    rescue StandardError => e
      add_error(@rows.first[:row_number], e.message)
    end

    private

    def status_should_be_imported
      @rows.first.dig(:row_hash, :current_status).in?(STATUSES_TO_BE_IMPORTED)
    end

    def validate_only_one_row
      return unless @rows.count > 1

      @rows.each do |row|
        add_error(row[:row_number], I18n.t('imports.import_errors.gef_project.duplicated'))
      end
    end

    def gef_project
      @gef_project ||= begin
        gef_project = GEFProject.find_or_initialize_by(gef_id: @gef_id)

        if gef_project.new_record?
          gef_project.title = @rows.first[:row_hash][:title]
          gef_project.save
        end

        gef_project
      end
    end

    def update_gef_project_from_rows(gef_project)
      row_number = @rows.first[:row_number]
      row_hash = @rows.first[:row_hash]
      gef_project_params = @mapper.new(gef_project, row_hash).call

      gef_project.assign_attributes(gef_project_params)

      # Add errors generated by the mapper
      gef_project.errors.full_messages.each { |message| add_error(row_number, message) }

      # Try to save the gef project
      return if gef_project.save

      # If the gef project failed to save, add the errors
      gef_project.errors.full_messages.each { |message| add_error(row_number, message) }
    end

    def add_error(row_number, message)
      @errors << { row_number:, message:, gef_project_id: gef_project.id }
    end
  end
end
