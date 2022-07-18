class CreateGeoregions < ActiveRecord::Migration[7.0]
  def change
    create_table :georegion_types do |t|
      t.string :name, null: false, index: true, unique: true
    end

    create_table :georegions do |t|
      t.string :name, null: false, index: true, unique: true
      t.string :iso, null: true, index: true, unique: true
      t.string :m49, null: true, index: true, unique: true
      t.belongs_to :georegion_type, null: false, foreign_key: true

      t.timestamps
    end

    create_table :gef_projects_georegions do |t|
      t.belongs_to :gef_project, foreign_key: true
      t.belongs_to :georegion, foreign_key: true
    end
  end
end
