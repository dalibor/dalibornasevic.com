ActionController::Routing::Routes.draw do |map|

  map.namespace :admin do |admin|
    admin.root :controller => 'posts'
    admin.resources :posts, :member => {:delete => :get}
  end

  map.resources :posts, :only => [:index, :show] do |post|
    post.resources :comments, :only => [:create]
  end
  
  map.root :controller => "posts"
  # map.root :controller => 'main', :action => 'about'

  map.about '/about', :controller => "main", :action => "about"
  #map.connect ':controller/:action/:id'
  #map.connect ':controller/:action/:id.:format'
end
