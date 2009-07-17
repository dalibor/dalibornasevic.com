class CommentsController < ApplicationController
  def create
    @post = Post.find(params[:post_id])
    @comment = @post.comments.new(params[:comment])

    if session[:spam_timestamp] && (Time.now.to_i - session[:spam_timestamp].to_i) >= Comment.minimum_wait_time
      if @comment.save
        flash[:notice] = "Your comment was successfully created."
        redirect_to @post
      else
        flash[:error] = "Please correct invalid data from the form."
        @comments = @post.comments
        render :template => 'posts/show'
      end
    else
      render :action => :spam
    end
  end
end