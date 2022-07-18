FactoryBot.define do
  factory :indicator_import do
    trait :with_errors do
      gef_project_import_errors { [association(:gef_project_import_error)] }
    end
  end
end
