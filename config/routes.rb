Blog::Application.routes.draw do
  get '/sitemap.:format' => 'main#sitemap', :as => :sitemap
  get '/feed.:format' => 'posts#feed', :as => :feed

  resources :posts, :only => [:index, :show]

  root :to => 'main#index'
end
