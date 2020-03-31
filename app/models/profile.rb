class Profile < ApplicationRecord
  belongs_to :user
  validates_uniqueness_of :user_id
  validates :user_id, presence: true
end
