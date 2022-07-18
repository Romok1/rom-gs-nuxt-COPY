class CreateGEFProjects < ActiveRecord::Migration[7.0]
  def change
    create_table :gef_projects do |t|
      t.string :gef_id, null: false, index: true, unique: true
      t.text :title, null: false, index: true
      t.string :short_title, null: true, index: true
      t.string :current_status, null: true, index: true
      t.string :project_grant, null: true, index: true
      t.date :received_by_gef_date, null: true, index: true
      t.date :concept_approval_date, null: true, index: true
      t.date :approved_for_implementation_date, null: true, index: true
      t.date :expected_completion_date, null: true, index: true
      t.date :actual_completion_date, null: true, index: true
      t.bigint :task_manager_id, null: true, index: true

      t.timestamps
    end
  end
end
