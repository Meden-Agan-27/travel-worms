class AddCountryToBooks < ActiveRecord::Migration[5.2]
  def change
    add_column :books, :country, :string
  end
end
