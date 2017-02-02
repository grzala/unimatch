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
    
    
    def show
        @con = Conversation.find_con(session[:user_id], params[:id])
        
        if @con == nil
            @con = Conversation.create(sender_id: session[:user_id], recipient_id: params[:id])
        end
        
        @msgs = @con.messages.all
        
        @users = {}
        @users[@con.sender_id] = User.find(@con.sender_id)
        @users[@con.recipient_id] = User.find(@con.recipient_id)
        
        @message = Message.new()
        
    end

    def create_message
        @message = Message.new(body: message_params[:body])
        
        puts "ASFASF"
        puts message_params[:recipient_id]
        
        @con = Conversation.find_con(session[:user_id], message_params[:recipient_id])
        
        @message.conversation_id = @con.id
        @message.user_id = session[:user_id]
        
        if @message.save
            redirect_to :controller => :conversation, :action => :show, :id => @con.recipient_id
        end
        
    end
    
    
    private
    
    def message_params
        params.require(:message).permit(:body, :recipient_id)
    end

end