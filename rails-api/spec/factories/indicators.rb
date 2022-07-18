# frozen_string_literal: true

FactoryBot.define do
  factory :indicator do
    sequence(:name) { |n| "Indicator #{n}" }
    parent_id { nil }
    sequence(:tag) { |n| "Indicator#{n}" }
    association :indicator_type, factory: :gef_core_indicator_type
  end
end
