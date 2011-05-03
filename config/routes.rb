Blog::Application.routes.draw do
  get '/login', :to => 'sessions#new', :as => 'login'
  get '/logout', :to => 'sessions#destroy', :as => 'logout'
  get '/tag/:tag' => 'posts#index', :as => :tag_posts, :constraints => { :tag => /.*/ }
  get '/date/:year/:month' => 'posts#index', :as => :date_posts
  get '/sitemap.:format' => 'main#sitemap', :as => :sitemap

  root :to => 'main#index'

  resource :session
  resources :posts, :only => [:index, :show] do
    resources :comments, :only => [:create]
  end

  namespace :admin do
    root :to => 'main#index'

    resources :posts do
      member do
        get :delete
      end
    end

    resources :comments do
      member do
        get :delete
        put :approve
        put :reject
      end

      collection do
        delete :destroy_multiple
      end
    end

    resources :attachments

    resources :editors
    resource :profile, :only => [:edit, :update]
  end

  match '/:id' => 'main#show', :as => :static
end
