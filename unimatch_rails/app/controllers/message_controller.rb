class MessageController < ApplicationController
    
    
  def create
    @message = Message.new(message_params)
    @message.sender_id = session[:user_id]
    @message.save
    redirect_to :controller => :user, :action => :messages, :id => @message.recipient_id
  end

    
  private
  def message_params
      params.require(:message).permit(:body, :recipient_id)
  end
end
