class ConversationsController < ApplicationController

before_action :authorize, :only => [:edit, :match, :choose_interests, :delete]

def authorize
    if session[:user_id] != params[:id].to_i then redirect_to :root end
end

def list
    @conversations= Conversation.all
end

def index
    @users = User.all
    @conversations = Conversation.all
end
def create
     #if Conversation.between(params[:sender_id],params[:recipient_id]).present? @conversation = Conversation.between(params[:sender_id],params[:recipient_id]).first
     @conversation = Conversation.new(conversation_params)
     #@conversation.save
   
    #end
     #redirect_to conversation_messages_path(@conversation)
     redirect_to action: 'list'
end


private
 def conversation_params
  params.permit(session[:user_id], :recipient_id)
 end
end
