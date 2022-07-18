class AddTagToIndicatorsAndCoreAreas < ActiveRecord::Migration[7.0]
  def change
    add_column :indicators, :tag, :string
    add_column :focal_areas, :tag, :string

    add_index :indicators, :tag, unique: true
    add_index :focal_areas, :tag, unique: true
  end
end
