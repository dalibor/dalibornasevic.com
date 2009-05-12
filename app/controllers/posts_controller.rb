class PostsController < ApplicationController
  def index
    @posts = Post.find(:all, :limit => 5, :order => 'created_at DESC')
  end

  def show
    @post = Post.find params[:id]
  end
end
