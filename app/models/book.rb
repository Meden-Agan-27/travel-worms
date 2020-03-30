class Book < ApplicationRecord
  validates_presence_of :title, :country, :language, :author, :genre
  validates :title, uniqueness: :true

  has_many :bookshelf_items, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_many :bookshelves, through: :bookshelf_items

  include PgSearch::Model
  pg_search_scope :search_by_country,
    against: :country,
    using: {
      tsearch: { prefix: true }
    }

  def average_rating
    sum = 0
    @reviews = self.reviews.each do |review|
      sum += review.rating
    end
    sum / self.reviews.count
  end

end
