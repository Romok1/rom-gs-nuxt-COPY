FactoryBot.define do
  factory :spatial_dataset_type do
    sequence(:name) { |n| "Spatial Layer #{n}" }
    type { 'SpatialDatasets::Geoserver' }
  end
end
