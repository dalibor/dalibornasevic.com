ActionController::Routing::Routes.draw do |map|

  map.namespace :admin do |admin|
    admin.root :controller => 'posts'
    admin.resources :posts, :member => {:delete => :get}
    admin.resources :comments, :member => {:delete => :get}
  end

  map.resources :posts, :only => [:index, :show] do |post|
    post.resources :comments, :only => [:create]
  end
  
  map.root :controller => 'posts'
  # map.root :controller => 'main', :action => 'about'

  map.about '/about', :controller => 'main', :action => 'about'
  map.lastfm_service 'services/lastfm', :controller => 'services', :action => 'lastfm'
  map.twitter_service 'services/twitter', :controller => 'services', :action => 'twitter'
  #map.connect ':controller/:action/:id'
  #map.connect ':controller/:action/:id.:format'
end
