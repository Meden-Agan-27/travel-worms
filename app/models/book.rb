class Book < ApplicationRecord
  validates_presence_of :title, :country, :language, :author, :genre
  validates :title, uniqueness: :true

  has_many :bookshelf_items, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_many :bookshelves, through: :bookshelf_items
end
