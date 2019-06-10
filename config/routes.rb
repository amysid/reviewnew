Rails.application.routes.draw do
  namespace :admin do
    get 'homes/index'
  end
  devise_for :users

  namespace :web do
    resources :users
   # root "users#index"
    # get 'users/detail'
  end

  namespace :admin do
    resources :users
    resources :static_content
    # root "users#index"
    # get 'users/index'
    # get 'users/show'
  
   get 'homes/index', as: "home_index"
  end
    root :to =>  "web/users#index"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
