xml.instruct!
xml.rss("version" => "2.0") do
  xml.channel do
    xml.title "Dalibor Nasevic"
    xml.link root_url
    xml.description "Dalibor Nasevic's blog"
    xml.language "en"
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
