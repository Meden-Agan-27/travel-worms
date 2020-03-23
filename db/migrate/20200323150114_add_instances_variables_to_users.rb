class AddInstancesVariablesToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :username, :string
    add_column :users, :city, :string
    add_column :users, :preferred_language, :string
  end
end
