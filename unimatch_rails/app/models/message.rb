class Message < ApplicationRecord
  belongs_to :user, :foreign_key => :sender_id
  belongs_to :conversation
  
  def message_time
      created_at.strftime('%m/%d/%y at %l:%M %p')
  end
  

end
#message belongs to conversation and to the user that receives it, foreign key is the sender