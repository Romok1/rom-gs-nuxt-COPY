class CreateTimelineEventsAndJoinTable < ActiveRecord::Migration[7.0]
  def change
    create_table :timeline_events do |t|
      t.string :name, index: true, unique: true

      t.timestamps
    end

    create_table :gef_projects_timeline_events do |t|
      t.date :date, null: false, index: true
      t.belongs_to :timeline_event, foreign_key: true
      t.belongs_to :gef_project, foreign_key: true

      t.timestamps
    end
  end
end
