module PostsHelper
  def posts_title
    if params[:tag].present?
      "Tagged with #{params[:tag]}"
    elsif params[:year].present?
      "Written in #{params[:year]}"
    else
      "All Blog Posts"
    end
  end
end
