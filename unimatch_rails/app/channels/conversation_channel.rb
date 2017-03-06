class ConversationChannel < ApplicationCable::Channel
  
  include Rails.application.routes.url_helpers
  
  def subscribed
     stream_from "conversation_channel_#{current_user.id}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def message(data)
    
    @conversation = Conversation.find(data['conversation_id'])
    @users = @conversation.get_users
    
    @users.each do |user|
      ActionCable.server.broadcast "conversation_channel_#{user.id}", data
      
      @senders = ""
      @users.each do |sender|
        if sender.id != user.id #not append the receiver, you know that YOU ARE RECEIPEIENENTNT
          @senders += sender.name + " " + sender.surname + ", "
        end
      end
      @senders = @senders[0...-2]
      
      user.notify(conversation_path(:id => @conversation.id), "You received a message from: " + @senders, @conversation.id)
    end
    
  end
end
