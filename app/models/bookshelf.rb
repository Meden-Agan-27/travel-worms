class Bookshelf < ApplicationRecord
  belongs_to :user
  has_many :bookshelf_items, dependent: :destroy
  has_many :books, through: :bookshelf_items
  validates_presence_of :name

  accepts_nested_attributes_for :bookshelf_items, reject_if: :all_blank
end
