class CreateGEFProjectImportErrors < ActiveRecord::Migration[7.0]
  def change
    create_table :gef_project_import_errors do |t|
      t.belongs_to :gef_project_import, foreign_key: true
      t.belongs_to :gef_project, index: true, null: true, foreign_key: true
      t.integer :row_number, default: false, null: false
      t.string :message

      t.timestamps
    end
  end
end
