class BookshelfItem < ApplicationRecord
  belongs_to :bookshelf
  belongs_to :book
  # validates :book, uniqueness: :true, on: :create
end
