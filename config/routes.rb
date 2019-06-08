Rails.application.routes.draw do
  devise_for :users

  namespace :web do
   root "users#index"
    get 'users/show'
    get 'users/detail'
  end

  namespace :admin do
    root "users#index"
    get 'users/index'
    get 'users/show'
  end
    root :to =>  "web/users#index"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
