module PostsHelper
  def posts_title
    if params[:tag].present?
      "Blog posts tagged with #{params[:tag]}"
    elsif params[:year].present?
      "Blog posts written in #{params[:year]}"
    else
      "Blog posts"
    end
  end
end
