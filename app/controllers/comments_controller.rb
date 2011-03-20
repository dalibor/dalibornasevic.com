class CommentsController < ApplicationController

  def create
    @post            = Post.where("comments_closed = 0").find(params[:post_id])
    @comment         = @post.comments.new(params[:comment])
    @comment.request = request

    if verify_recaptcha(:model => @comment) && @comment.save
      flash[:notice] = "Your comment was successfully created."
      redirect_to @post
    else
      if @comment.valid?
        flash.now[:error] = "Please enter correct reCaptcha."
      else
        flash.now[:error] = "Please correct invalid data from the form."
      end
      render 'new'
    end
  end
end
