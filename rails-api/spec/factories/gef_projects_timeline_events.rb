FactoryBot.define do
  factory(:gef_projects_timeline_event) do
    date {}
    gef_project
    timeline_event
  end
end
