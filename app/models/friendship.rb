class Friendship < ApplicationRecord
  belongs_to :asker, class_name: "User"
  belongs_to :receiver, class_name: "User"
  validates_presence_of :asker_id, :receiver_id
  validates :asker, uniqueness: {scope: :receiver}
end


#scope for the uniqueness of the users so they can't keep adding friends.
