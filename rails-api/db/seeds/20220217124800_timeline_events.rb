# frozen_string_literal: true

timeline_events = YAML.load_file(Rails.root.join('db/data/timeline_events.yml'))
TimelineEvent.create!(timeline_events.map(&:deep_symbolize_keys))
