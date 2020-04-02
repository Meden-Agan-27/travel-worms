class FriendshipsController < ApplicationController

# step 1: Display all users through ProfileController (Went with no display unless search)
# step 2: Show 1 user profile
# step 3: Being able to send a friendship request
# step 4: default status: pending
# step 5: other user accepts/declines invite (check rentApet)
# step 6: if users are friends, bookshelves are visible
# step 7: see notification when new friendship request comes in

  def create
    @asker = current_user
    @receiver = User.find(params[:receiver_id])
    @friendship = Friendship.create(asker_id: @asker.id, receiver_id: @receiver.id)
  end

  def accept
    raise
  end

  def decline

  end


end
