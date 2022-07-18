class AddDiscardedAtToGEFProjects < ActiveRecord::Migration[7.0]
  def change
    add_column :gef_projects, :discarded_at, :datetime
    add_index :gef_projects, :discarded_at
  end
end
