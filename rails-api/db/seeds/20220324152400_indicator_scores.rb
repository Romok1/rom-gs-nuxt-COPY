return if Rails.env.production? # import indicator scores from Sharepoint on production instead

indicator_scores = YAML.load_file(Rails.root.join('db/data/indicator_scores.yml'))
indicator_score_params = indicator_scores.map(&:deep_symbolize_keys)

indicator_score_params = indicator_score_params.map do |params|
  {
    indicator_id: Indicator.find_by(name: params[:indicator]).id,
    gef_project_id: GEFProject.find_by(gef_id: params[:gef_project_id]).id,
    value: params[:value],
    year: params[:year],
    assessment_type: params[:assessment_type]
  }
end

IndicatorScore.create!(indicator_score_params)
