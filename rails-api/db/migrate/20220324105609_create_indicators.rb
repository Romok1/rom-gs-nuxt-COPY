class CreateIndicators < ActiveRecord::Migration[7.0]
  def change
    create_table :indicator_types do |t|
      t.string :name, null: false

      t.timestamps
    end

    create_table :indicators do |t|
      t.text :name, null: false, index: true
      t.belongs_to :indicator_type, foreign_key: true
      t.integer :parent_id, null: true, index: true

      t.timestamps
    end
  end
end
