Rails.application.routes.draw do
  mount Ckeditor::Engine => '/ckeditor'
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
    resources :users do
      collection do
        post :import
      end
    member do
        post :status
        get :admin_profile
        get :edit_admin_profile
        patch :update_admin_profile
        post :add_category
      end
    end
    resources :static_content
    resources :categories
    # root "users#index"
    # get 'users/index'
    # get 'users/show'
  
   get 'homes/index', as: "home_index"
  end
    root :to =>  "web/users#index"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
