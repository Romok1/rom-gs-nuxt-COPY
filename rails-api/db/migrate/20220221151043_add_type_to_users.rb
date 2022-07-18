class AddTypeToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :type, :string, null: false, default: 'TaskManager'
  end
end
