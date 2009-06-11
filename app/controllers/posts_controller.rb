class PostsController < ApplicationController
  def index
    @posts = Post.paginate(:page => params[:page], :per_page => 5, :order => 'created_at DESC')
  end

  def show
    @commentable = Post.find params[:id]
    @comment = Comment.new
    @comments = @commentable.comments
  end
end
