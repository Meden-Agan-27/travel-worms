class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home]

  def home
  end

  def update_user
  end

  def user_index #add a search for username in this function
    @users = User.all
  end
end
