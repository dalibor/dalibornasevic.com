Blog::Application.routes.draw do
  get '/sitemap.:format' => 'main#sitemap', :as => :sitemap

  resources :posts, :only => [:index, :show]

  root :to => 'main#index'
end
