xml.instruct!
xml.urlset "xmlns" => "http://www.sitemaps.org/schemas/sitemap/0.9" do
  xml.url do
    xml.loc "http://dalibornasevic.com"
    xml.priority 1.0
  end

  @tags.each do |tag|
    xml.url do
      xml.loc posts_url(tag: tag)
      xml.priority 0.9
    end
  end

  @posts.each do |post|
    xml.url do
      xml.loc post_url(post)
      xml.lastmod post.date.to_date
      xml.priority 0.9
    end
  end
end
