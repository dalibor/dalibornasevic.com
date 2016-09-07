module ApplicationHelper
  def title(page_title)
    content_for(:title) { page_title }
  end

  def keywords(page_keywords)
    content_for(:keywords) { page_keywords } if page_keywords.present?
  end

  def description(page_description)
    content_for(:description) { page_description } if page_description.present?
  end

  def page_image(page_image)
    if page_image.present?
      image = page_image.starts_with?('http') ? page_image : "#{root_url.chop}#{page_image}"
      content_for(:page_image) { image }
    end
  end

  def javascript(*files)
    content_for(:head) { javascript_include_tag(*files) }
  end

  def stylesheet(*files)
    content_for(:head) { stylesheet_link_tag(*files) }
  end

  def personal_description
    "Software Engineer working at GoDaddy on the email delivery infrastructure and email marketing products"
  end
end
