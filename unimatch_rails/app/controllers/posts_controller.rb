class PostsController < ApplicationController
    
    def society_send
       @user = User.find(session[:user_id])
       @soc = Society.find(params[:society_id])
       @soc.add_post(@user.id, params[:post])
       
       redirect_to :back
    end
    
    def event_send
       @user = User.find(session[:user_id])
       @event = Event.find(params[:event_id])
       @event.add_post(@user.id, params[:post])
       
       redirect_to :back
    end
end
