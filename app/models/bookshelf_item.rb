class BookshelfItem < ApplicationRecord
  belongs_to :bookshelf
  belongs_to :book
  # validates :book, uniqueness: true
  validates_uniqueness_of :book_id, :scope => :bookshelf_id
end
