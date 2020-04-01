class FriendshipsController < ApplicationController

# step 1: Display all users through ProfileController (Went with no display unless search)
# step 2: Show 1 user profile
# step 3: Being able to send a friendship request
# step 4: default status: pending
# step 5: other user accepts/declines invite (check rentApet)
# step 6: if users are friends, bookshelves are visible
# step 7: see notification when new friendship request comes in

  def create
    @friendship = Friendship.new
  end

  def accept
  end

  def decline
  end


end
