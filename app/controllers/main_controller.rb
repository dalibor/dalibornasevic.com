class MainController < ApplicationController

  before_filter :load_archive, only: [:index]

  def index
    @posts = Post.all.reverse.first(15)
  end

  def sitemap
    @posts = Post.all.reverse
    @tags  = Post.all_tags
  end
end
