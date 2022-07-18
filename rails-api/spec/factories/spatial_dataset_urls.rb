FactoryBot.define do
  factory :spatial_dataset_url do
    spatial_dataset
    sequence(:url) { |n| "Spatial Layer url #{n}" }
    sequence(:date) { |n| Date.today - n.years }
  end
end
