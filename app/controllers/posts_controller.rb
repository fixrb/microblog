# frozen_string_literal: true

class PostsController < ApplicationController
  before_action :require_user

  def create
    @post = current_user.posts.new(params.expect(post: [:body]))

    if @post.save
      redirect_to root_path
    else
      @posts = current_user.timeline
      render "timelines/show", status: 422
    end
  end
end
