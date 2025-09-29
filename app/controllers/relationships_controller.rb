class RelationshipsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user

  def create
    if current_user != @user && !current_user.following?(@user)
      current_user.follow(@user)
    end
    redirect_back fallback_location: users_path
  end

  def destroy
    if current_user.following?(@user)
      current_user.unfollow(@user)
    end
    redirect_back fallback_location: users_path
  end

  private
  def set_user
    @user = User.find(params[:user_id])
  end
end