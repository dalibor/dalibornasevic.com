class MainController < ApplicationController

  def index
    @posts = Post.published.order('created_at DESC').limit(10)
  end

  def show
    render params[:id]
  end

  def sitemap
    @posts = Post.order('published_at DESC').where(:publish => true)
    @tags  = Tag.order('name ASC')
  end
end
