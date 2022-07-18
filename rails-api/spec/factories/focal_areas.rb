FactoryBot.define do
  factory(:focal_area) do
    sequence(:name) { |n| "Focal Area #{n}" }
  end
end
