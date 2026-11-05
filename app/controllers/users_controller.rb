# frozen_string_literal: true

# The profile of a user: their posts, and a button to follow them.
class UsersController < ApplicationController
  def show
    @user = User.find_by!(handle: params[:handle])
    @posts = @user.posts.newest_first
  end
end
