class ConversationChannel < ApplicationCable::Channel
  def subscribed
     stream_from "conversation_#{params['conversation_room_id']}_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def message(data)
    
    ActionCable.server.broadcast "conversation_#{data['conversation_room_id']}_channel", data
    
  end
end
