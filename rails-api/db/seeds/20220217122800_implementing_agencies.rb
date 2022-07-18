# frozen_string_literal: true

implementing_agencies = YAML.load_file(Rails.root.join('db/data/implementing_agencies.yml'))
ImplementingAgency.create!(implementing_agencies.map(&:deep_symbolize_keys))
