xml.instruct!
xml.rss("version" => "2.0", "xmlns:atom" => "http://www.w3.org/2005/Atom") do
  xml.channel do
    xml.title "Dalibor Nasevic"
    xml.link root_url
    xml.description "Dalibor Nasevic's blog"
    xml.language "en"
    xml.tag!("atom:link", "href" => posts_url(:format => "rss"), "rel" => "self", "type" => "application/rss+xml")
    for post in @posts
      xml.item do
        xml.title post.title
        xml.description post.content
        xml.pubDate post.date.to_s(:rfc822)
        xml.link post_url(post)
        xml.guid post_url(post)
        xml.author "dalibor.nasevic@gmail.com (Dalibor Nasevic)"
      end
    end
  end
end
