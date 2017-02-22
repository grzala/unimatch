Rails.application.routes.draw do

  
  controller :society do
     get '/society/list' => :list
     get '/society/join/:id' => :join_leave
    get '/society/match/:id' => :match
  end
  resources :society
  
  controller :event do
    get '/event/list' => :list
    get '/event/join/:id' => :join_leave
    
  end
  resources :event
  
  resources :message
  
  controller :user do
    get '/user/list' => :list
    post '/user/:id' => :update
    get '/user/match/:id' => :match
    get '/user/choose/:id' => :choose_interests
    post '/user/choose/:id' => :update_interests, :as => :update_interests
    get 'user/:id/messages' => :messages
  end
  
  resources :user
  
  controller :session do
    get  'login' => :new
    post 'login' => :create
    get 'logout' => :destroy
  end
  
  root :to => 'welcome#index'
  
  controller :welcome do
    get '/welcome' => :index
  end

  
  #match ':controller'(/:action(/:id))', :via => get

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
