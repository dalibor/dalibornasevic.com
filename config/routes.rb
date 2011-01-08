ActionController::Routing::Routes.draw do |map|

  map.namespace :admin do |admin|
    admin.root :controller => 'posts'
    admin.resources :posts, :member => {:delete => :get}
    admin.resources :comments, :member => {:delete => :get, :approve => :put, :reject => :put}, :collection => {:destroy_multiple => :delete}
  end

  map.resources :posts, :only => [:index, :show] do |post|
    post.resources :comments, :only => [:create]
  end

  map.root :controller => 'posts'
  map.tag_posts 'tag/:tag', :controller => 'posts', :action => 'index'
  map.about '/about', :controller => 'main', :action => 'about'
end
