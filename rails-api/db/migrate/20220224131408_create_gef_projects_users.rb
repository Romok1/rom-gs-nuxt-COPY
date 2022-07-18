class CreateGEFProjectsUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :role_id, :bigint, index: true, null: true
    remove_column :users, :type, :string, index: true, null: false
    remove_column :gef_projects, :task_manager_id, :bigint, index: true, null: true

    create_table :roles do |t|
      t.string :name, index: true, null: false

      t.timestamps
    end

    create_table :gef_projects_users do |t|
      t.belongs_to :gef_project, foreign_key: true
      t.belongs_to :user, foreign_key: true
      t.belongs_to :role, foreign_key: true

      t.timestamps
    end
  end
end
