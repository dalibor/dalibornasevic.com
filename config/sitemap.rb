# Set the host name for URL creation
SitemapGenerator::Sitemap.default_host = "http://#{BLOG_URL}"

SitemapGenerator::Sitemap.add_links do |sitemap|
  # Put links creation logic here.
  #
  # The root path '/' and sitemap index file are added automatically.
  # Links are added to the Sitemap in the order they are specified.
  #
  # Usage: sitemap.add(path, options={})
  #        (default options are used if you don't specify)
  #
  # Defaults: :priority => 0.5, :changefreq => 'weekly',
  #           :lastmod => Time.now, :host => default_host
  #
  #
  # Examples:
  #
  # Add '/articles'
  #
  #   sitemap.add articles_path, :priority => 0.7, :changefreq => 'daily'
  #
  # Add individual articles:
  #
  #   Article.find_each do |article|
  #     sitemap.add article_path(article), :lastmod => article.updated_at
  #   end

  Tag.find(:all).each do |tag|
    sitemap.add tag_posts_path(tag.name), :lastmod => tag.updated_at,
                               :changefreq => 'daily',
                               :priority => 0.5
  end

  Post.find(:all, :conditions => 'published_at IS NOT NULL').each do |post|
    sitemap.add post_path(post), :lastmod => post.updated_at,
                               :changefreq => 'daily',
                               :priority => 0.8
  end
end
