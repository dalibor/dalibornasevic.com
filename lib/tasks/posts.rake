namespace :posts do
  desc "Cache posts"
  task :cache => :environment do
    Post.cache_all
  end
end
