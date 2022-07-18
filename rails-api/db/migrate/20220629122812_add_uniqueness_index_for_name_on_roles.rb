class AddUniquenessIndexForNameOnRoles < ActiveRecord::Migration[7.0]
  def change
    add_index :roles, :name, unique: true, name: 'role_name_is_unique'
  end
end
