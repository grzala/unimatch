class Conversation < ApplicationRecord
    belongs_to :user, :foreign_key => :sender_id
    belongs_to :user, :foreign_key => :recipient_id
    
    has_many :messages, dependent: :destroy
    
    validates_uniqueness_of :sender_id, :scope => :recipient_id
    
    validate :swap_arguments

    def swap_arguments
        id1 = self.sender_id
        id2 = self.recipient_id
        @con  = Conversation.find_by_sender_id_and_recipient_id(id1, id2)
        if @con != nil  then errors.add(:sender_id, "conversation already exists") end
        @con  = Conversation.find_by_sender_id_and_recipient_id(id2, id1)
        puts @con == nil
        if @con != nil then errors.add(:sender_id, "conversation already exists") end
    end
    
    def Conversation.find_con(sender_id, recipient_id)
        @con = find_by_sender_id_and_recipient_id(sender_id, recipient_id)
        if @con == nil
            @con = find_by_sender_id_and_recipient_id(recipient_id, sender_id)
        end
        return @con
    end
        
end