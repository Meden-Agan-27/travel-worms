class AddDefaultStatusToFriendships < ActiveRecord::Migration[5.2]
  def change
    change_column_default :friendships, :status, from: nil, to:"pending"
  end
end
