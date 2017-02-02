class MessageController < ApplicationController
    
    
  def create
    #@message = Message.new(message_params)
    @message.body = message_params[:body]
    if @message.save
    redirect_to :controller => :conversation, :action => :show, :id => @message.conversation_id
 end
  
  end

    
  private
  def message_params
    params.require(:message).permit(:body, :user_id, :conversation_id)
  end
end
