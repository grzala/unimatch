class ConversationChannel < ApplicationCable::Channel
  def subscribed
     stream_from "conversation_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def message(data)
    
    ActionCable.server.broadcast "conversation_channel", data
    
  end
end
