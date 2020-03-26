class AddOriginalTitleToBooks < ActiveRecord::Migration[5.2]
  def change
    add_column :books, :original_title, :string
  end
end
