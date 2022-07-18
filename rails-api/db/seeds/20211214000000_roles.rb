# frozen_string_literal: true

roles = YAML.load_file(Rails.root.join('db/data/roles.yml'))
Role.create!(roles.map(&:deep_symbolize_keys))
