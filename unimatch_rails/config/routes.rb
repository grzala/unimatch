Rails.application.routes.draw do
  
  
  get '/user/list' => 'user#list'
  post 'user/:id' => 'user#update'
  resources :user
  
  #match ':controller'(/:action(/:id))', :via => get

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
