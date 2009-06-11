class CommentsController < ApplicationController
  
  
  def create
    @commentable = find_commentable
    @comment = @commentable.comments.new(params[:comment])
    
    if @comment.save
      flash[:notice] = "Your comment was successfully created."
      redirect_to @commentable
    else
      @comments = @commentable.comments
      render :template => 'posts/show'
    end
  end
  
  private
  def find_commentable
    params.each do |key, value|
      if key =~ /(.+)_id/
        return $1.classify.constantize.find(value)
      end
    end
  end
end
