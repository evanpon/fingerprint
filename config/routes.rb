Rails.application.routes.draw do

  resources :common_terms 
  get 'login' => 'common_terms#login'
  post 'authenticate' => 'common_terms#authenticate'
  
  get 'home/index'
  post 'home/search'
  root 'home#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
