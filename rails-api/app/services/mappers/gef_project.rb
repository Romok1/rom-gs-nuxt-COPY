# frozen_string_literal: true

module Mappers
  class GEFProject
    EXPECTED_HEADERS = {
      gef_id: 'GEF ID',
      implementing_agencies: 'Lead GEF Agency',
      countries: 'Country',
      regions: 'Geographic Scope',
      title: 'Project title',
      short_title: 'Project Short Title',
      task_manager: 'Task Manager',
      current_status: 'Current Project Status',
      pa_focal_point: 'PA focal point',
      fmo: 'FMO',
      project_grant: 'Project Grant',
      fa_focal_point: 'FA Focal Point',
      mid_term_evaluation_status: 'Project mid-term review/evaluation status',
      terminal_evaluation_status: 'Project terminal evaluation status',
      project_closed_date: 'Date of project financial closure',
      focal_areas: 'Focal Area_A',
      unep_signature_date: 'UNEP Signature Date (Project)',
      pif_approval_date: 'PIF/Council Approval Date',
      project_endorsement_date: 'Project CEO Approval/Endorsement Date',
      expected_completion_date: 'Expected Technical Completion date (Project)',
      revised_completion_date: 'Revised Technical Completion date (Project)',
      actual_completion_date: 'Actual Technical Completion date (Project)'
    }.freeze

    # Will also be added to the projects sheet:
    # 1. 'Date of latest signature date on the umbrella legal instrument'
    ## 'Project Start Date' will be latest of the above and :unep_signature_date
    # 2. 'First_Installment'
    # 3. 'MTR_Date'
    # 4. 'TE_Date'

    # VALID_STATUSES should be updated in nuxt-frontend/constants.js GEF_PROJECT_VALID_STATUSES as well.
    VALID_STATUSES = ['Completed', 'Not Completed', 'N/A', 'Ongoing', 'Under Implementation'].freeze

    def initialize(
      gef_project,
      row_hash,
      record_from_string_service = Mappers::RecordFromString.new,
      timeline_events_service = Mappers::GEFProjectsTimelineEvents
    )
      @gef_project = gef_project
      @row_hash = row_hash
      @record_from_string_service = record_from_string_service
      @timeline_events_service = timeline_events_service
    end

    def expected_headers
      EXPECTED_HEADERS
    end

    def call
      {
        title: extract_spreadsheet_value(:title),
        short_title: extract_spreadsheet_value(:short_title),
        current_status: extract_spreadsheet_value(:current_status),
        project_grant: extract_spreadsheet_value(:project_grant),
        mid_term_evaluation_status: status(:mid_term_evaluation_status),
        terminal_evaluation_status: status(:terminal_evaluation_status),
        gef_projects_users_attributes:,
        georegion_ids: georegion_ids_from_names,
        implementing_agency_ids: implementing_agency_ids_from_names,
        focal_area_ids: focal_area_ids_from_names,
        gef_projects_timeline_events_attributes:
      }
    end

    private

    def status(status_type)
      # @TODO: When the spreadsheet has been updated we should probably add
      # an error if the status is not one of the expected statuses.
      status = extract_spreadsheet_value(status_type)
      status_string = status&.strip if status.is_a?(String)
      if status_string.in?(VALID_STATUSES) || status_string.blank?
        status_string
      else
        add_error(I18n.t('imports.import_errors.gef_project.invalid_status', status: status_string))
        nil
      end
    end

    def extract_spreadsheet_value(key)
      return nil unless Mappers::GEFProject::EXPECTED_HEADERS.keys.include?(key)

      @row_hash[key]
    end

    def georegion_ids_from_names
      georegion_names_string = "#{extract_spreadsheet_value(:countries)}, #{extract_spreadsheet_value(:regions)}"
      georegion_names_string.gsub!(/(R|r)egional|[()]/, ',') # remove 'Region' and parentheses
      georegion_names_string.gsub!("\n", ' ') # remove next lines
      georegion_names = georegion_names_string.split(',').map(&:strip).select(&:present?).uniq

      record_ids_from_strings(georegion_names, Georegion)
    end

    def implementing_agency_ids_from_names
      implementing_agencies_string = extract_spreadsheet_value(:implementing_agencies) || ''
      implementing_agency_names = implementing_agencies_string.split(%r{/|,}).map(&:strip).select(&:present?).uniq

      record_ids_from_strings(implementing_agency_names, ImplementingAgency)
    end

    def focal_area_ids_from_names
      focal_areas_string = extract_spreadsheet_value(:focal_areas) || ''
      focal_area_names = focal_areas_string.split(%r{\(|\)|/|,}).map(&:strip).select(&:present?).uniq

      record_ids_from_strings(focal_area_names, FocalArea)
    end

    def record_ids_from_strings(string_array, klass)
      ids = []
      string_array.each do |string|
        record = @record_from_string_service.call(string, klass)

        if record
          ids << record.id
        else
          add_error(I18n.t('imports.import_errors.gef_project.not_found', type: klass.to_s, name: string))
        end
      end
      ids
    end

    def gef_projects_users_attributes
      attributes = []

      %i[task_manager fmo fa_focal_point pa_focal_point].each do |user_role|
        role_name = EXPECTED_HEADERS[user_role]
        role = Role.where('name ILIKE ?', "%#{role_name}%").first
        user_name = extract_spreadsheet_value(user_role)

        if user_name.present?
          user = User.where('name ILIKE ?', "%#{user_name.strip}%").first
          if user.nil?
            # @TODO: update expression to something more relevant once known
            user = User.create(name: user_name, email: "#{user_name.gsub(/\s+/, '').downcase}@test.com",
              password: 'password1')
          end

          if user.persisted?
            gef_projects_users_id = GEFProjectsUser.find_by(gef_project_id: @gef_project.id, role_id: role.id)&.id
            attributes << { id: gef_projects_users_id, user_id: user.id, role_id: role.id }
          else
            add_error(I18n.t('imports.import_errors.gef_project.user_error', role: EXPECTED_HEADERS[user_role], name: user_name.strip,
              message: user.errors.full_messages.join(', ')))
          end
        elsif @gef_project.send(user_role)
          gef_projects_users_id = GEFProjectsUser.find_by(gef_project_id: @gef_project.id, role_id: role.id).id
          attributes << { id: gef_projects_users_id, _destroy: true }
        end
      end
      attributes
    end

    def gef_projects_timeline_events_attributes
      @timeline_events_service.new(@gef_project, @row_hash).call
    end

    def add_error(error)
      @gef_project.errors.add(:base, error)
    end
  end
end
