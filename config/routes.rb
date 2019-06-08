Rails.application.routes.draw do
  devise_for :users
  namespace :web do
   
    get 'users/show'
    get 'users/detail'
  end
  root :to =>  "web/users#index"
  namespace :admin do
    get 'users/index'
    get 'users/show'
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
