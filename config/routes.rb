Rails.application.routes.draw do
  get '/auth/facebook/callback' , to: 'users/sessions#create_user'

  mount Ckeditor::Engine => '/ckeditor'
  namespace :admin do
    get 'homes/index'
  end
  #devise_for :users
     devise_for :users, controllers: {
        sessions: 'users/sessions',
        passwords: 'users/passwords',
        omniauth_callbacks: "users/omniauth_callbacks" 
        #registrations: 'users/registrations'
      }


  namespace :web do
    resources :categories do
    collection do
      get :review_system
    end
    end

    resources :reviews do
      collection do
        post :get_reviews
        post :get_vote_for_review
      end
    end
    resources :users do
    collection do
      get :read_full_review
      get :check_email
      get :check_email_login
      post :image_update
      get :report
      get :report_details
      get :user_score
      get :hollframe
      get :user_type
      get :trending
      get :upcomeing
      get :holl_of_fame_details
      get :categorywise
      get :rating_calculate
    end
    member do
      get :user_profile
      get :movie_category
      get :movie_category_detail
      get :movie_detail
      get :movie_review
      get :full_review
    end
   end 
  end

  namespace :admin do
    resources :users do
      collection do
        post :import
        get :change_admin_password
        # get :feedback
      end
    member do
        get :status
        get :admin_profile
        get :edit_admin_profile
        patch :update_admin_profile
        patch :type_user
        patch :expert_user
        # get :show_feedback
        # delete :destroy_feedback
      end
    end
    resources :faqs
    resources :feedbacks
    resources :static_content
    resources :categories do
      collection do
        get :edit_sub_category
        get :edit_review_part
       delete :destroy_sub_category
       delete :destroy_review_part
        post :create_sub_category
        post :create_post_review
        post :update_sub_category
        post :update_review_part
        get :add_category
        post :create_category_details
        get :search_sub_categories
      end
    end
    resources :products do
      collection do
        get :sub_categories_by_category
      end
      member do 
        patch :publish
        patch :unpublish
        patch :trending
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
        get :feedback
        get :contact_us
      end
    end
    root :to =>  "web/users#index"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
