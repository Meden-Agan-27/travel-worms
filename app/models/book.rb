class Book < ApplicationRecord
  validates_presence_of :title, :language, :genre, :author
  has_many :bookshelf_items, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_many :bookshelves, through: :bookshelf_items

  def average_rating
    sum = 0
    @reviews = self.reviews.each do |review|
      sum += review.rating
    end
    sum / self.reviews.count
  end
end
