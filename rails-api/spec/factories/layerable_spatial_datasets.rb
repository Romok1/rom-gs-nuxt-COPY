FactoryBot.define do
  factory :layerable_spatial_dataset do
    spatial_dataset
    layerable { |layerable| layerable.association(:focal_area) }
  end
end
