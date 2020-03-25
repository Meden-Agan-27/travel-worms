class Book < ApplicationRecord
  validates_presence_of :title, :country, :language, :author
  validates :title, uniqueness: :true
  # Raphaëlle removed the genre in validation for the scraping phase
  has_many :bookshelf_items, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_many :bookshelves, through: :bookshelf_items
end
