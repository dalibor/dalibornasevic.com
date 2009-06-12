class PostsController < ApplicationController
  def index
    @posts = Post.paginate(:page => params[:page], :per_page => 5, :order => 'created_at DESC')
    respond_to do |format|
      format.html
      format.rss { render :layout => false}
    end
  end

  def show
    @post = Post.find params[:id]
    @comments = @post.comments
    @comment = Comment.new
  end
end
