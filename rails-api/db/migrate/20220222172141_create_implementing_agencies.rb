class CreateImplementingAgencies < ActiveRecord::Migration[7.0]
  def change
    create_table :implementing_agencies do |t|
      t.string :name, index: true, null: false, unique: true
      t.string :alternative_names, index: true, null: true, unique: true

      t.timestamps
    end

    create_table :gef_projects_implementing_agencies do |t|
      t.belongs_to :gef_project,
        index: { name: 'gef_projects_implementing_agencies_index' },
        foreign_key: true
      t.belongs_to :implementing_agency,
        index: { name: 'implementing_agencies_gef_projects_index' },
        foreign_key: true
    end
  end
end
