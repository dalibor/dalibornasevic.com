Blog::Application.routes.draw do
  get '/sitemap.:format' => 'main#sitemap', :as => :sitemap

  resources :posts, :only => [:index, :show]

  # Redirect old tag routes
  get "/tag/:name" => redirect { |params, request| "/posts?tag=#{params[:name]}" }

  root :to => 'main#index'
end
