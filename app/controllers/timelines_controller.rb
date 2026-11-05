# frozen_string_literal: true

# The home page: a form for a new post, then the timeline of the user.
class TimelinesController < ApplicationController
  before_action :require_user

  def show
    @post = Post.new
    @posts = current_user.timeline
  end
end
