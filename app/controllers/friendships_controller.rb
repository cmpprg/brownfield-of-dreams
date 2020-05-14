class FriendshipsController < ApplicationController
  def create
    Friendship.create(friendship_params)
    redirect_to dashboard_path
  end

  private

  def friendship_params
    { user_id: current_user.id, friend_id: gather_friend_id }
  end

  def gather_friend_id
    User.find_by(github_uid: params[:friend_uid]).id
  end
end
