class ConversationChannel < ApplicationCable::Channel
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
    end
    
  end
end
