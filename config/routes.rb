ActionController::Routing::Routes.draw do |map|


  map.namespace :admin do |admin|
    admin.root :controller => 'posts'
    admin.resources :posts, :member => {:delete => :get}
  end

  map.resources :posts, :only => [:index, :show]
  map.root :controller => "posts"

  map.about '/about', :controller => "main", :action => "about"
  #map.connect ':controller/:action/:id'
  #map.connect ':controller/:action/:id.:format'
end
