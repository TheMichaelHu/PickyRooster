class FriendsController < ApplicationController
  before_action :set_friend, only: :destroy

  def index
    @friends = current_user.friends
  end

  def show
    @friend = User.find(params[:id])
  end

  def destroy
    current_user.remove_friend(@friend)
    head :no_content
  end

  def search
      @users = User.all.map(&:email)
      if params[:search]
          @users = User.search(params[:search]).map(&:email)
      else
          @users = User.all.order("email").map(&:email)
      end
  end

  private

  def set_friend
    @friend = current_user.friends.find(params[:id])
  end
end
