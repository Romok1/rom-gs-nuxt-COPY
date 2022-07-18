# frozen_string_literal: true

module Builders
  class Indicators
    def initialize(gef_id, rows, errors, indicator_mapper = Mappers::Indicator)
      @gef_id = gef_id
      @rows = rows
      @errors = errors
      @indicator_mapper = indicator_mapper
    end

    def call
      return unless gef_project

      gef_project.indicator_import_errors.destroy_all
      # We need a record of the indicator scores in the database for this
      # gef_project at the start of the import and the ones updated in the
      # import, in order to destroy any that are no longer in the spreadsheet.
      # This could happen if a user changes the contents of a cell in the
      # spreadsheet or deletes a row.
      indicator_score_ids_before_import = gef_project.indicator_score_ids

      rows_grouped_by_indicator = @rows.group_by do |row|
        row.dig(:row_hash, :sub_indicator) || row.dig(:row_hash, :core_indicator)
      end

      rows_grouped_by_indicator.each do |indicator_name, indicator_rows|
        if has_expected_results_value?(indicator_rows)
          add_baseline(indicator_rows) unless row_for_baseline?(indicator_rows)
          update_gef_project_from_rows(gef_project, indicator_rows)
        else
          # If Expected values are missing, we can't summarise the
          # data in charts so do not import and add errors
          indicator_rows.each do |row|
            add_error(row[:row_number], I18n.t('imports.import_errors.indicator.missing_expected_results',
              indicator_name:))
          end
        end
      end
      # Destroy indicator scores that were not in the spreadsheet.
      indicator_score_ids_no_longer_in_spreadsheet = [indicator_score_ids_before_import - indicator_score_ids_from_spreadsheet]
      gef_project.indicator_scores.where(id: indicator_score_ids_no_longer_in_spreadsheet).destroy_all
    rescue StandardError => e
      @rows.each do |row|
        add_error(row[:row_number], e.message)
      end
    end

    private

    def row_for_baseline?(indicator_rows)
      indicator_rows.pluck(:row_hash).pluck(:timeline).include?('Baseline')
    end

    def add_baseline(indicator_rows)
      # Assumed basline score is 0 if there is no baseline recorded in the
      # data sheet. We need to create that here manually or calculating
      # summaries later becomes more difficult.
      new_row = indicator_rows.first.dup
      new_row[:row_hash][:timeline] = 'Baseline'
      new_row[:row_hash][:pir_year] = nil
      if new_row[:row_hash][:core_indicator_value].present?
        new_row[:row_hash][:core_indicator_value] = 0
      else
        new_row[:row_hash][:sub_indicator_value] = 0
      end
      indicator_rows << new_row
    end

    def indicator_score_ids_from_spreadsheet
      []
    end

    def has_expected_results_value?(rows)
      timelines = rows.map { |row| row.dig(:row_hash, :timeline) }
      timelines.include?('Expected Results')
    end

    def gef_project
      @gef_project ||= GEFProject.find_by(gef_id: @gef_id)
    end

    def update_gef_project_from_rows(gef_project, indicator_rows)
      indicator_rows.each do |row|
        update_gef_project_from_row(gef_project, row)
      end
    end

    def update_gef_project_from_row(gef_project, row)
      row_number = row[:row_number]
      row_hash = row[:row_hash]

      gef_project_params = @indicator_mapper.new(gef_project, row_hash).call

      if gef_project.errors.empty?
        indicator_score_ids_from_spreadsheet << gef_project_params[:indicator_scores_attributes].first[:id]

        gef_project.assign_attributes(gef_project_params)

        # Try to save the gef project
        gef_project.save
      end

      gef_project.errors.full_messages.each { |message| add_error(row_number, message) }
      gef_project.errors.clear # Clear errors so they don't get added to multiple rows
    rescue StandardError => e
      add_error(row_number, e.message)
    end

    def destroy_import_errors(gef_project)
      gef_project.gef_project_import_errors.destroy_all
    end

    def add_error(row_number, message)
      @errors << { row_number:, message:, gef_project_id: gef_project.id }
    end
  end
end
