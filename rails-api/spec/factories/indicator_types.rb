# frozen_string_literal: true

FactoryBot.define do
  factory :indicator_type do
    factory :gef_core_indicator_type do
      name { 'GEF Core Indicator' }
    end

    factory :mts_indicator_type do
      name { 'UNEP MTS Indicator' }
    end
  end
end
