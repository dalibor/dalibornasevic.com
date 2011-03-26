module ApplicationHelper
  def title(page_title)
    content_for(:title) { page_title }
  end

  def keywords(page_keywords)
    content_for(:keywords) { page_keywords } unless page_keywords.blank?
  end

  def description(page_description)
    content_for(:description) { page_description } unless page_description.blank?
  end

  def javascript(*files)
    content_for(:head) { javascript_include_tag(*files) }
  end

  def stylesheet(*files)
    content_for(:head) { stylesheet_link_tag(*files) }
  end

  def gravatar_url(email)
    gravatar_id = Digest::MD5.hexdigest(email.downcase)
    "http://gravatar.com/avatar/#{gravatar_id}.png?s=48"
    #if user.avatar_url.present?
      #user.avatar_url
    #else
      #default_url = "#{root_url}images/guest.png"
      #gravatar_id = Digest::MD5.hexdigest(user.email.downcase)
      #"http://gravatar.com/avatar/#{gravatar_id}.png?s=48&d=#{CGI.escape(default_url)}"
    #end
  end

  def body_id
    controller.controller_path.split('/').push(controller.action_name).join('_')
  end
end
