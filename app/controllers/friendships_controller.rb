class FriendshipsController < ApplicationController
before_action :find_friendship, only: [ :accept, :decline ]
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
    flash[:notice] = "Friend request sent!"
    redirect_to profile_path(@receiver.profile)
  end

  def accept
    @friendship.status = 'accepted'
    @friendship.save
    flash[:notice] = "Friend request accepted!"
    redirect_to profile_path(current_user)
  end

  def decline
    @friendship.status = 'declined'
    @friendship.save
    flash[:notice] = "Friend request declined!"
    redirect_to profile_path(current_user)
  end


  private
  def find_friendship
    @friendship = Friendship.find(params[:friendship_id])
  end

end
