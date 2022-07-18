class CreateFocalAreasAndJoinTable < ActiveRecord::Migration[7.0]
  def change
    create_table :focal_areas do |t|
      t.string :name, index: true, null: false
      t.string :alternative_names, index: true, null: true

      t.timestamps
    end

    create_table :focal_areas_gef_projects do |t|
      t.belongs_to :gef_project, foreign_key: true
      t.belongs_to :focal_area, foreign_key: true
    end
  end
end
