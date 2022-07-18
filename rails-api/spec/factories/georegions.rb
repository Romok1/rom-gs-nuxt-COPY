FactoryBot.define do
  factory :georegion do
    name {}
    iso {}
    m49 {}

    factory :country do
      name { "Name of Country" }
      iso { "ISO" }
      m49 { "M49" }
      georegion_type factory: :georegion_type_country 
    end

    factory :region do
      name { "Name of region" }
      georegion_type factory: :georegion_type_region 
    end
  end
end
