class RemoveDateFieldsFromGEFProjects < ActiveRecord::Migration[7.0]
  def change
    remove_column :gef_projects, :expected_completion_date
    remove_column :gef_projects, :revised_completion_date
    remove_column :gef_projects, :actual_completion_date
    remove_column :gef_projects, :received_by_gef_date
    remove_column :gef_projects, :concept_approval_date
    remove_column :gef_projects, :approved_for_implementation_date
  end
end
