class ChangeGEFProjectsFields < ActiveRecord::Migration[7.0]
  def change
    add_column :gef_projects, :mid_term_evaluation_status, :string, index: true, null: true
    add_column :gef_projects, :terminal_evaluation_status, :string, index: true, null: true
    add_column :gef_projects, :revised_completion_date, :date, index: true, null: true
  end
end
