class Message < ApplicationRecord
  belongs_to :user, :foreign_key => :sender_id
  belongs_to :user, :foreign_key => :recipient_id
  #validates_presence_of :body, :conversation_id, :user_id
  def message_time
      created_at.strftime('%m/%d/%y at %l:%M %p')
  end
  
  def Message.get_messages(id1, id2)
    @m = []
    @m += Message.where(sender_id: id1, recipient_id: id2)
    @m += Message.where(sender_id: id2, recipient_id: id1)
    return @m
  end

end
