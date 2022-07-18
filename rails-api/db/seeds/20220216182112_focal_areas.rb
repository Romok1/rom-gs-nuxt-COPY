# frozen_string_literal: true

focal_areas = YAML.load_file(Rails.root.join('db/data/focal_areas.yml'))
FocalArea.create!(focal_areas.map(&:deep_symbolize_keys))