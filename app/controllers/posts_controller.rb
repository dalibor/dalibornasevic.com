class PostsController < ApplicationController

  before_filter :load_archive, only: [:index, :show]

  def index
    @posts = scope.order('published_at DESC').includes('tags').
                   where('published_at IS NOT NULL')

    respond_to do |format|
      format.html
      format.rss { render :layout => false}
    end
  end

  def show
    @post = Post.where('published_at IS NOT NULL').find(params[:id])
  end

  private
  def scope
    @scope = if params[:tag].present? && (tag = Tag.find_by_name(params[:tag]))
      tag.posts
    else
      Post
    end

    if params[:year].present?
      @scope = @scope.where("YEAR(published_at) = ?", params[:year])
    end

    if params[:month].present?
      @scope = @scope.where("MONTH(published_at) = ?", params[:month])
    end

    @scope
  end

  def load_archive
    @posts_by_year = Post.posts_by_year
  end
end
