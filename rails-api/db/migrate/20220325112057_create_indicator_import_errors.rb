class CreateIndicatorImportErrors < ActiveRecord::Migration[7.0]
  def change
    create_table :indicator_import_errors do |t|
      t.belongs_to :indicator_import, foreign_key: true
      t.belongs_to :gef_project, optional: true, foreign_key: true
      t.integer :row_number, default: false, null: false
      t.string :message

      t.timestamps
    end
  end
end
