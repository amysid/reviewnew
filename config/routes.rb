Rails.application.routes.draw do
  namespace :web do
    get 'users/index'
    get 'users/show'
  end
  namespace :admin do
    get 'users/index'
    get 'users/show'
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
