# frozen_string_literal: true

return if Rails.env.production? # import GEF Projects from Sharepoint on production instead

gef_projects = YAML.load_file(Rails.root.join('db/data/gef_projects.yml'))
gef_projects_params = gef_projects.map(&:deep_symbolize_keys)

gef_projects_params.map do |project|
  gef_projects_users_attributes = []
  %i[task_manager fmo fa_focal_point pa_focal_point].each do |role_name|
    next unless project[role_name].present?

    role = Role.where('name ILIKE ?', role_name).first
    user = User.find_or_initialize_by(name: project[role_name])
    if user.new_record?
      user.email = "#{project[role_name].gsub(/\s+/, '')}@test.com"
      user.password = 'password'
      user.save!
    end
    gef_projects_users_attributes << { role:, user: }
  end
  project[:gef_projects_users_attributes] = gef_projects_users_attributes

  georegions = project[:georegions].split(',').map do |georegion_name|
    Georegion.where(name: georegion_name.strip).first
  end
  project[:georegions] = georegions

  gef_projects_timeline_events_attributes = []
  %i[
    received_by_gef_date
    concept_approval_date
    approved_for_implementation_date
    project_closed_date
  ].each do |event_type|
    next unless project[event_type]

    gef_projects_timeline_events_attributes << { date: project[event_type],
    timeline_event: TimelineEvent.find_by(name: TimelineEvent.event_name(event_type)) }
  end

  project[:gef_projects_timeline_events_attributes] = gef_projects_timeline_events_attributes

  implementing_agencies = project[:implementing_agencies].split(',').map do |implementing_agency|
    ImplementingAgency.where(name: implementing_agency.strip).first
  end
  project[:implementing_agencies] = implementing_agencies

  focal_areas = project[:focal_areas].split(',').map do |focal_area|
    FocalArea.where(name: focal_area.strip).first
  end
  project[:focal_areas] = focal_areas
end

gef_projects_params = gef_projects_params.map do |params|
  params.except(*%i[task_manager fmo fa_focal_point pa_focal_point received_by_gef_date pif_approval_date])
end

GEFProject.create!(gef_projects_params)
