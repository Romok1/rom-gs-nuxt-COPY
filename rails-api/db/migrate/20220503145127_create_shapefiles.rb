class CreateShapefiles < ActiveRecord::Migration[7.0]
  def change
    create_table :shapefiles do |t|
      t.belongs_to :gef_project, foreign_key: true
      t.integer :status, null: false, default: 0
      t.text :shapefile_error, null: true

      t.timestamps
    end
  end
end
