class AddAlternativeTitlesToBooks < ActiveRecord::Migration[5.2]
  def change
    add_column :books, :fra_title, :string
    add_column :books, :spa_title, :string
  end
end
