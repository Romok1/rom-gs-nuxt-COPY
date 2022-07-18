# frozen_string_literal: true

namespace :import do
  desc 'Import GEF Project and GEF core indicator data'
  task sharepoint_data: :environment do
    puts 'Importing GEF Projects'
    gef_project_import = GEFProjectImport.create
    Importers::Sharepoint.new(gef_project_import).call

    puts 'Importing GEF Core Indicators'
    indicator_import = IndicatorImport.create
    Importers::Sharepoint.new(indicator_import).call

    # @TODO: Remove this when we allow role selection on first log in
    puts 'setting task managers'
    task_manager_role_id = Role.task_manager.id
    User.joins(:gef_projects_users)
      .where(gef_projects_users: { role_id: task_manager_role_id })
      .update_all(role_id: task_manager_role_id)

    puts 'Imports complete'
  end
end
