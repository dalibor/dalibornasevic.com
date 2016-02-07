xml.instruct!
xml.rss("version" => "2.0", "xmlns:dc" => "http://purl.org/dc/elements/1.1/") do
  xml.channel do
    xml.title "Dalibor Nasevic"
    xml.link posts_path(:format => "rss")
    xml.description "Dalibor Nasevic's blog"
    xml.language "en-gb"
    for post in @posts
      xml.item do
        xml.title h(post.title)
        xml.description post.content
        xml.pubDate post.date.to_s(:rfc822)
        xml.link post_url(post)
        xml.guid post_url(post)
      end
    end
  end
end
