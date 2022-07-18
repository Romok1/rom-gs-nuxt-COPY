class CreateIndicatorImports < ActiveRecord::Migration[7.0]
  def change
    create_table :indicator_imports do |t|
      t.timestamps
    end
  end
end
