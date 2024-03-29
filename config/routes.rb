Rails.application.routes.draw do
  devise_for :users do
    get '/users/sign_out' => 'devise/sessions#destroy'
  end
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'
# devise_scope :user do
#   root to: "products#index"
# end
  root 'products#index'
  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products
  resources :products do
    #put 'scrape_amazon', to: 'products#'
  end
  resources :user_reviews
  put 'products/:id/scrape_amazon', to: 'products#scrape_amazon', as: 'product_scrape_amazon'
  put 'products/:id/scrape_engadget', to: 'products#scrape_engadget', as: 'product_scrape_engadget'

  resources :critic_reviews

  get 'products_recommend', to: 'products#recommend', as: 'product_recommend'
    post 'likes/create_like', to: 'likes#create_like'
    post 'likes/create_possession', to: 'likes#create_possession'
    post 'likes/create_dislike', to: 'likes#create_dislike'
  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
