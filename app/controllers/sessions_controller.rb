# frozen_string_literal: true

# Signing in is picking a handle: a new one is created on the spot. There are
# no passwords in this example; a real application would put them here.
class SessionsController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.find_or_initialize_by(handle: params.expect(:handle))

    if @user.save
      reset_session
      session[:user_id] = @user.id
      redirect_to root_path
    else
      render :new, status: 422
    end
  end

  def destroy
    reset_session
    redirect_to new_session_path
  end
end
