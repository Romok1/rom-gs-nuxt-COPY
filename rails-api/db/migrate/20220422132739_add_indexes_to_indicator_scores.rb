class AddIndexesToIndicatorScores < ActiveRecord::Migration[7.0]
  def change
    add_index :indicator_scores, :value
  end
end
