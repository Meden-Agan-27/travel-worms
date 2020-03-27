class Bookshelf < ApplicationRecord
  belongs_to :user
  has_many :bookshelf_items, dependent: :destroy
  has_many :books, through: :bookshelf_items
  validates_presence_of :name

end
