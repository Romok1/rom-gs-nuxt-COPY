class AddOrderToTimelineEvents < ActiveRecord::Migration[7.0]
  def change
    add_column :timeline_events, :order, :integer, index: true
  end
end
