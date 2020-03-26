class Review < ApplicationRecord
  belongs_to :book
  belongs_to :user
  validates_presence_of :review_content, :rating

  def average_rating
    if
      @reviews >= 1
      @reviews = self.class.average(:rating)
    else
      return "There are no reviews for this book yet."
    end
  end
end
