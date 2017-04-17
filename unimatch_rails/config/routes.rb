Rails.application.routes.draw do
  
  root :to => 'welcome#index'
  get '/index' => 'welcome#index'
  
  controller :society do
      get '/society/list' => :list
      get '/society/join/:id' => :join_leave
      get '/society/match' => :match
      post '/society/switch_admin' => :switch_admin
      post '/society/wall' => :wall
  end
  resources :society
  
  controller :event do
    get '/event/list' => :list
    get '/event/join/:id' => :join_leave
    
  end
  resources :event
  
  controller :user do
    #get 'user/:id' => :show
    #get 'user/slug/edit' => :edit
    get '/user/all/list' => :list
    post '/user/switch_favourite' => :switch_favourite
    post '/user/:id' => :update
    get '/user/match' => :match
    get '/user/choose/:id' => :choose_interests, :as => :choose_interests
    post '/user/choose/:id' => :update_interests, :as => :update_interests
  end
  resources :user
  
  controller :session do
    post '/register' => :register
    get '/register' => :new
    get 'logout' => :destroy
  end

  
  controller :welcome do
    post '' => :create
  end
  
  controller :conversation do
    get '/conversation/:id' => :show, :as => :conversation
    get '/conversation/message/:id' => :message
    post '/conversation/create_message' => :create_message, :as => :create_message
    post '/message' => :get_messages
  end
  
  controller :notification do
    post '/notification' => :get_notifications
    post '/notification/mark_seen' => :mark_seen
  end
  
  controller :event do
    post '/event/inviteallmembers' => :invite_all_members
    post '/event/invite' => :invite
    post '/event/wall' => :wall
  end
  
  controller :posts do
    post '/posts/society_send' => :society_send
    post '/posts/event_send' => :event_send
  end
  
  get '/search' => 'search#query'
  
  mount ActionCable.server => '/cable'

  
  #match ':controller'(/:action(/:id))', :via => get

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
