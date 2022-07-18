FactoryBot.define do
  factory :spatial_dataset do
    sequence(:name) { |n| "Spatial Layer #{n}" }
    sequence(:description) { |n| "Spatial Layer description #{n}" }
    spatial_dataset_type
  end
end
