xml.instruct!

xml.feed "xmlns" => "http://www.w3.org/2005/Atom" do
  xml.generator "dalibornasevic.com", "uri" => "http://dalibornasevic.com", "version" => "1.0.0"
  xml.link "href" => "http://dalibornasevic.com/feed.xml", "rel" => "self", "type" => "application/atom+xml"
  xml.link "href" => "http://dalibornasevic.com", "rel" => "alternate", "type" => "text/html"
  if @posts.present?
    xml.updated @posts.first.date.to_s(:rfc2822)
  end
  xml.id "http://dalibornasevic.com"
  xml.title "Dalibor Nasevic"
  for post in @posts
    xml.entry do
      xml.title xml_escape(post.title)
      xml.link "href" => post_url(post), "rel" => "alternate", "type" => "text/html", "title" => h(post.title)
      xml.published post.date.to_s(:rfc2822)
      xml.updated post.date.to_s(:rfc2822)
      xml.id post_url(post)
      xml.content xml_escape(post.content), "type" => "html", "xml:base" => post_url(post)
      xml.author do
        xml.name "Dalibor Nasevic"
        xml.email "dalibor.nasevic@gmail.com"
        xml.uri "http://dalibornasevic.com"
      end
      for tag in post.tags
        xml.category "term" => tag
      end
      if post.summary.present?
        xml.summary strip_html(post.summary)
      end
    end
  end
end
