# frozen_string_literal: true

gef_core_indicators = YAML.load_file(Rails.root.join('db/data/gef_core_indicators.yml'))
gef_core_indicators_params = gef_core_indicators.map(&:deep_symbolize_keys)

gef_core_indicator_type = IndicatorType.find_by(name: 'GEF Core Indicator')

gef_core_indicators_params.each do |params|
  params[:parent] = Indicator.find_by_name(params[:parent_indicator]) if params[:parent_indicator].present?
  params[:indicator_type] = gef_core_indicator_type
  Indicator.create!(params.except(:parent_indicator))
end