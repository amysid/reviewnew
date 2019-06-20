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
        patch :type_user
        patch :expert_user
      end
    end
    resources :static_content
    resources :categories do
      collection do
        get :add_category
        post :create_category_details
      end
    end
      get 'homes/index', as: "home_index"
  end
   resources :homes do
      collection do
        get :about_us
        get :faq
        get :privacy_policy
        get :term_condition
      end
    end
    root :to =>  "web/users#index"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
