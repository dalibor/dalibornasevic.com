class PostsController < ApplicationController
  def index
    
    conditions = {:page => params[:page], :per_page => 5, :order => 'created_at DESC', :include => :tags, :conditions => 'published_at IS NOT NULL'}
    
    @posts = if !params[:tag].blank? && (tag = Tag.find_by_name(params[:tag]))
      tag.posts.paginate(conditions)
    else
      Post.paginate(conditions)
    end
    
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
