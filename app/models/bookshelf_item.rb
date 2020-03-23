class BookshelfItem < ApplicationRecord
  belongs_to :bookshelf
  belongs_to :book
end
