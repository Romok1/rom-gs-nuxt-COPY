FactoryBot.define do
  factory :georegion_type do
    name {}

    factory :georegion_type_country do
      name { 'country' }
    end

    factory :georegion_type_region  do
      name { 'region' }
    end
  end
end
