Rails.application.routes.draw do
  
  controller :user do
    get '/user/list' => :list
    post '/user/:id' => :update
    get '/user/match/:id' => :match
    get '/user/choose/:id' => :choose_interests
    post '/user/choose/:id' => :update_interests, :as => :update_interests
  end
  resources :user
  
  controller :session do
    get  'login' => :new
    post 'login' => :create
    get 'logout' => :destroy
  end
  
  root "session#new"
  
  #match ':controller'(/:action(/:id))', :via => get

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
