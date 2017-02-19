module ApplicationHelper
  def page_title
    @page_title
  end

  def page_keywords
    @page_keywords
  end

  def page_description
    @page_description
  end

  def page_image
    if @page_image
      @page_image.starts_with?('http') ? @page_image : "#{root_url.chop}#{@page_image}"
    end
  end
end
