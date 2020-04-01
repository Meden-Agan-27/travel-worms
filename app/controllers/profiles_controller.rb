class ProfilesController < ApplicationController

  def index
    if params[:query].present?
      @user = User.where(username: params[:query])
      if @user.empty?
        @profile = nil
      else
        @profile = @user[0].profile
      end
    end
  end

  def show
    @profile = Profile.find(params[:id])
  end

  def new
    @profile = Profile.new
  end

  def edit
    @profile = Profile.find(params[:id])
  end

  def create
    @profile = Profile.new(profile_params)
    @profile.user = current_user
    @profile.save
    redirect_to profiles_path
  end

  def update
    @profile = Profile.find(params[:id])
    @profile.update(profile_params)
    redirect_to profile_path(@profile)
  end

  def destroy
    @profile = Profile.find(params[:id])
    @profile.destroy
    redirect_to profiles_path
  end

  private

  def profile_params
      params.require(:profile).permit(:first_name, :last_name, :about, :photo)
  end

end
