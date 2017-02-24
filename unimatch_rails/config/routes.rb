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
  
  root :to => 'welcome#index'
  
  controller :welcome do
    get '/welcome' => :index
  end
  
  controller :conversation do
    get '/conversation/:id' => :show
    get '/conversation/message/:id' => :message
    post '/conversation/create_message' => :create_message, :as => :create_message
  end

  
  #match ':controller'(/:action(/:id))', :via => get

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
