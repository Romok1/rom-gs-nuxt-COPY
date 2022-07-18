# frozen_string_literal: true

indicator_types = YAML.load_file(Rails.root.join('db/data/indicator_types.yml'))
indicator_type_params = indicator_types.map(&:deep_symbolize_keys)

IndicatorType.create(indicator_type_params)