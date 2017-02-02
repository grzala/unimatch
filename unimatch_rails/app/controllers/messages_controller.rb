class MessagesController < ApplicationController
before_action :set_conversation

def index
    
    @messages = @conversation.messages.all
    #if @messages.length > 10
     #   @over_ten = true
      #  @messages = @messages[-10..-1]
    #end
    #if params[:m]
     #   @over_ten = false
      #  @messages = @conversation.messages
    #end
    #if @messages.last
     #   if @messages.last.user_id != current_user.id
      #      @messages.last.read = true;
       # end
    #end
    #@message = @conversation.Messages.new
end

#def new
 #   @message = @conversation.messages.new(message_params)
#end


def create
    @message = @conversation.Message.new(message_params)
    if @message.save
    redirect_to conversation_messages_path(@conversation)
    end
end



private
 def set_conversation
    @conversation = Conversation.find(params[:id])
 end

 def message_params
  params.require(:message).permit(:body, :user_id, :conversation_id)
  #params.require(:conversation)
 end
end
