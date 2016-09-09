module ApplicationHelper
  def page_title
    @page_title || "Dalibor Nasevic"
  end

  def page_keywords
    @page_keywords || "dalibor, nasevic, ruby, rails"
  end

  def page_description
    @page_description || "Software Engineer working at GoDaddy on the email delivery infrastructure and email marketing products"
  end

  def page_image
    if @page_image
      @page_image.starts_with?('http') ? @page_image : "#{root_url.chop}#{@page_image}"
    else
      "#{request.base_url}/assets/dalibor.nasevic.jpg"
    end
  end
end
