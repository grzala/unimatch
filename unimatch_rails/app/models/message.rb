class Message < ApplicationRecord
  belongs_to :conversation, :foreign_key => :conversation_id, class_name: 'Conversation'
  belongs_to :user, class_name: 'User'
  #validates_presence_of :body, :conversation_id, :user_id
  def message_time
      created_at.strftime('%m/%d/%y at %l:%M %p')
  end


end
