# frozen_string_literal: true

FactoryBot.define do
  factory :indicator_score do
    gef_project
    indicator
    value {}
    year {}
    assessment_type { 'baseline' }
  end
end
