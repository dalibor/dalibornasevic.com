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

  def xml_escape(input)
    CGI.escapeHTML(input.to_s)
  end

  def strip_html(input)
    empty = ''.freeze
    input.to_s.gsub(/<script.*?<\/script>/m, empty).
      gsub(/<!--.*?-->/m, empty).
      gsub(/<style.*?<\/style>/m, empty).
      gsub(/<.*?>/m, empty)
  end
end
