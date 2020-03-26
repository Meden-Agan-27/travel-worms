class AddImageAndAuthorToBooks < ActiveRecord::Migration[5.2]
  def change
    add_column :books, :image, :string
    add_column :books, :author, :string
  end
end
