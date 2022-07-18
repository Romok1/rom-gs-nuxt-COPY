FactoryBot.define do
  factory :gef_project do
    sequence(:gef_id) { |n| "GEF ID #{n}" }
    sequence(:title) { |n| "GEF project title #{n}" }
    sequence(:short_title) { |n| "short title #{n}" }
    current_status { ['CEO Endorsed', 'Closed', 'Completed'].sample }
    project_grant { '$1000000' }

    trait :with_georegions do
      georegions { [create(:region), create(:country)] }
    end

    # used to create a project with a user in a specific role, e.g.
    # build(:gef_project_with_user_with_role, user: task_manager, role: task_manager_role)
    factory :gef_project_with_user_with_role do
      transient do
        user {}
        role {}
      end

      after(:build) do |gef_project, evaluator|
        create(:gef_projects_user, gef_project:, user: evaluator.user, role: evaluator.role)
        gef_project.reload
      end
    end
  end
end
