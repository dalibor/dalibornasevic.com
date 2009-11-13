begin
  require 'big_sitemap'
rescue LoadError
end
desc 'Generate XML Sitemap'
task :sitemap => :environment do
  sitemap = BigSitemap.new(:url_options => {:host => BLOG_URL}, :gzip => false, :path => '')

  sitemap.add(Tag, {
    :path => 'tag',
    :change_frequency => 'daily',
    :priority         => 0.5
  })

  sitemap.add(Post, {
    :conditions       => 'published_at IS NOT NULL',
    :change_frequency => 'daily',
    :priority         => 0.8
  })

  # Generate the files
  sitemap.generate
  sitemap.ping_search_engines
end
