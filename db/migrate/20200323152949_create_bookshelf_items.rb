class CreateBookshelfItems < ActiveRecord::Migration[5.2]
  def change
    create_table :bookshelf_items do |t|
      t.references :bookshelf, foreign_key: true
      t.references :book, foreign_key: true
      t.string :status, default: "to read"

      t.timestamps
    end
  end
end
