require 'rubygems'
require 'builder'

xml = Builder::XmlMarkup.new(:indent => 2, :target => File.open("coments.xml", "w"))
xml.instruct! :xml, :version=>"1.0", :encoding=>"UTF-8"
xml.rss 'version' => "2.0",
        'xmlns:content' => "http://purl.org/rss/1.0/modules/content/",
        'xmlns:dsq' => "http://www.disqus.com/",
        'xmlns:dc' => "http://purl.org/dc/elements/1.1/",
        'xmlns:wp' => "http://wordpress.org/export/1.0/" do
  xml.channel do
    Post.all.each do |post|
      if post.published_at
        xml.item do
          xml.title post.title
          xml.link Rails.application.routes.url_helpers.post_url(post, :host => 'dalibornasevic.com')
          xml.content(:encoded) { |x| x << "" }
          xml.dsq(:thread_identifier) { |x| x << post.id.to_s }
          xml.wp(:post_date_gmt) { |x| x << post.published_at.utc.to_formatted_s(:db) }
          xml.wp(:comment_status) { |x| x << "open" }
          post.comments.each do |comment|
            xml.wp(:comment) do
              xml.wp(:comment_id) { |x| x << comment.id.to_s }
              xml.wp(:comment_author) { |x| x << comment.name }
              xml.wp(:comment_author_email) { |x| x << comment.email }
              xml.wp(:comment_author_url) { |x| x << comment.url }
              xml.wp(:comment_author_IP) { |x| x << comment.user_ip }
              xml.wp(:comment_date_gmt) { |x| x << comment.created_at.utc.to_formatted_s(:db) }
              xml.wp(:comment_content) { |x| x.cdata!(comment.content) }
              xml.wp(:comment_approved) { |x| x << '1' } # approve
              xml.wp(:comment_parent) { |x| x << '0' }
            end
          end
        end
      end
    end
  end
end
