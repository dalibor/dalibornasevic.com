class CommentsController < ApplicationController

  def create
    @post            = Post.available_for_commenting.find(params[:post_id])
    @comment         = @post.comments.new(params[:comment])
    @comment.request = request

    if @comment.save
      flash[:notice] = "Thanks for commenting!"
      redirect_to post_url(@post)
    else
      flash.now[:error] = "Please correct invalid fields."
      render 'new'
    end
  end
end
