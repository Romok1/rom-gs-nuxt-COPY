class CreateGEFProjectImports < ActiveRecord::Migration[7.0]
  def change
    create_table :gef_project_imports do |t|
      t.timestamps
    end
  end
end
