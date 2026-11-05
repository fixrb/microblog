# frozen_string_literal: true

class FollowsController < ApplicationController
  before_action :require_user

  def create
    user = User.find_by!(handle: params[:user_handle])
    follow = current_user.active_follows.new(followed: user)

    if follow.save
      redirect_to user
    else
      redirect_to user, alert: follow.errors.full_messages.to_sentence
    end
  end

  def destroy
    user = User.find_by!(handle: params[:user_handle])
    current_user.active_follows.destroy_by(followed: user)

    redirect_to user
  end
end
