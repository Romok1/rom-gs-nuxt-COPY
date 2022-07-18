class CreateIndicatorScores < ActiveRecord::Migration[7.0]
  def change
    create_table :indicator_scores do |t|
      t.float :value, null: true
      t.string :period, null: false, index: true
      t.belongs_to :gef_project, foreign_key: true
      t.belongs_to :indicator, foreign_key: true

      t.timestamps
    end
  end
end
