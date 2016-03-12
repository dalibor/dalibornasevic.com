class ApplicationController < ActionController::Base
  protect_from_forgery

  private

  def load_archive
    @posts_by_year = Post.by_year
  end
end
