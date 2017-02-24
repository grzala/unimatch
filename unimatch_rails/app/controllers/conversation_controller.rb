class ConversationController < ApplicationController
    
    
    def show
        @con = Conversation.find(params[:id])
        
        if !@con.is_member?(User.find(session[:user_id]))
            flash[:warning] = "YOU DONT GET TO DO THAT"
            redirect_to root_path
        end
        
        @msgs = @con.get_messages
        
        @msgs = @msgs.sort_by { |msg| msg.created_at }
        
        @conusers = @con.get_users
        
        @users = {}
        @users[@conusers[0].id] = @conusers[0]
        @users[@conusers[1].id] = @conusers[1]
        
        @message = Message.new()
        
		respond_to do |format|
			format.html { 
			    
			}
			
			format.json {
				render json: @msgs
			}
	    end
        
    end
    
    def get_messages
        @con = Conversation.find(params[:id])
        
        @msgs = @con.get_messages
    end
    
    def message
        @user1 = User.find(session[:user_id])
        @user2 = User.find(params[:id])
        
        @con = Conversation.find_conversation(@user1, @user2)
        
        if @con.nil?
           @con = Conversation.create_between(@user1, @user2)
        end
        
        redirect_to :action => :show, :id => @con.id
    end
    
    def create_message
        @message = Message.new()
        
        @user = User.find(session[:user_id])
        @con = Conversation.find(params[:conversation_id])
        
        if !@con.is_member?(@user)
            flash[:warning] = "YOU DONT GET TO DO THAT"
            redirect_to root_path
            return
        end
        
        @message.body = params[:body]
        @message.conversation_id = @con.id
        @message.sender_id = @user.id
        @message.save
    end
    
    
end
    