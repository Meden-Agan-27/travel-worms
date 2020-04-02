class FriendshipsController < ApplicationController

# step 1: Display all users through ProfileController (Went with no display unless search)
# step 2: Show 1 user profile
# step 3: Being able to send a friendship request
# step 4: default status: pending
# step 5: other user accepts/declines invite (check rentApet)
# step 6: if users are friends, bookshelves are visible
# step 7: see notification when new friendship request comes in

  def index
    @friendships = Friendship.all
  end

  def create
    @asker_id = current_user.id
    @receiver_id = params[:receiver_id].to_i
    @friendship = Friendship.create(asker_id: @asker_id, receiver_id: @receiver_id)
  end

  def accept
  end

  def decline
  end


end
