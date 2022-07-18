class CreateShapefileImportErrors < ActiveRecord::Migration[7.0]
  def change
    create_table :shapefile_import_errors do |t|
      t.belongs_to :shapefile, foreign_key: true
      t.string :message
      t.timestamps
    end

    remove_column :shapefiles, :shapefile_error, :string
  end
end
