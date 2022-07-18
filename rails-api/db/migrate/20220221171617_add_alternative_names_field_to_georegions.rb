class AddAlternativeNamesFieldToGeoregions < ActiveRecord::Migration[7.0]
  def change
    add_column :georegions, :alternative_names, :string, index: true
  end
end
