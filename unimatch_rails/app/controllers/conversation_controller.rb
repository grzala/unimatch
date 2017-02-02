class ConversationController < ApplicationController

#before_action :authorize, :only => [:edit, :match, :choose_interests, :delete]

def authorize
    if session[:user_id] != params[:id].to_i then redirect_to :root end
end

def user
   @user=session[:user_id] 
end

#def list
#    @conversations= Conversation.all
#end

def index
    @users = User.all
    @conversations=Conversation.all
    
   # puts @conversations
end

def new
    @conversation = Conversation.new
       
end

def show
end


def create
    @conversation = Conversation.new(conversation_params)
    if @conversation.save then
        redirect_to @conversation, notice:"Created"
    else
        @con = Conversation.find_by_sender_id_and_recipient_id(conversation_params[:sender_id], conversation_params[:recipient_id])
        redirect_to :action => :show, :id => @con.id
    end
    
end


private
 def conversation_params

  #params.permit(session[:user_id], :recipient_id)
  #@already=1
  params.require(:conversation).permit(:sender_id, :recipient_id)
  #params.require(:conversation)
 end
end