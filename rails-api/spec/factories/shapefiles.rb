FactoryBot.define do
  factory :shapefile do
    gef_project
    status { :processing }
  end
end
