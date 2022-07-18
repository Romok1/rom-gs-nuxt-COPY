class CreateSpatialLayersTables < ActiveRecord::Migration[7.0]
  def change
    create_table :spatial_dataset_types do |t|
      t.string :name, null: false, unique: true
      t.string :type, null: false

      t.timestamps
    end

    create_table :spatial_datasets do |t|
      t.string :name, unique: true, null: false
      t.text :description, null: false
      t.belongs_to :spatial_dataset_type, polymorphic: true

      t.timestamps
    end

    create_table :spatial_dataset_urls do |t|
      t.string :url, null: false
      t.date :date, null: true
      t.belongs_to :spatial_dataset, foreign_key: true

      t.timestamps
    end

    create_table :layerable_spatial_datasets do |t|
      t.references :layerable, polymorphic: true
      t.belongs_to :spatial_dataset, foreign_key: true

      t.timestamps
    end

    add_index :spatial_dataset_urls, %i[date spatial_dataset_id], unique: true
  end
end
