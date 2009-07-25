class CommentsController < ApplicationController
  has_rakismet :only => :create
  
  def create
    @post = Post.find(params[:post_id])
    @comment = @post.comments.new(params[:comment])
    @comment.request = request
    
    if @comment.save
      if @comment.approved?
        flash[:notice] = "Your comment was successfully created."
      else
        flash[:error] = "Unfortunately this comment is considered spam by Akismet. It will show up once it has been approved by the administrator."
      end
      redirect_to @post
    else
      flash[:error] = "Please correct invalid data from the form."
      @comments = @post.comments
      render :template => 'posts/show'
    end
  end
end