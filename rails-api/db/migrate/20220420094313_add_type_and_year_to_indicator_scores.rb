class AddTypeAndYearToIndicatorScores < ActiveRecord::Migration[7.0]
  def change
    add_column :indicator_scores, :year, :integer
    add_column :indicator_scores, :assessment_type, :integer
    remove_column :indicator_scores, :period, :string

    add_index :indicator_scores, :year
    add_index :indicator_scores, :assessment_type
  end
end
