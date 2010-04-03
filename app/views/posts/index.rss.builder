xml.instruct!
xml.rss("version" => "2.0", "xmlns:dc" => "http://purl.org/dc/elements/1.1/") do
  xml.channel do
    xml.title RSS_TITLE
    xml.link posts_path(:format => 'rss')
    xml.description RSS_DESCRIPTION
    xml.language "en-gb"
    for post in @posts
      xml.item do
        xml.title h(post.title)
        xml.description textilize(post.content)
        xml.pubDate post.published_at.to_s(:rfc822)
        xml.link post_url(post)        
        xml.guid post_url(post)
      end
    end
  end
end
