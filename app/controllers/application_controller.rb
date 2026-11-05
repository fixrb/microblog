# frozen_string_literal: true

class ApplicationController < ActionController::Base
  helper_method :current_user

  private

  # The user signed in, if any.
  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  # Sends a visitor who is not signed in to the sign-in page.
  def require_user
    redirect_to new_session_path unless current_user
  end
end
