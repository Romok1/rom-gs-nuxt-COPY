class AddStatusToImporters < ActiveRecord::Migration[7.0]
  def change
    add_column :gef_project_imports, :status, :integer, default: 0
    add_column :indicator_imports, :status, :integer, default: 0
  end
end
