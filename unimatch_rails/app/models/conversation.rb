class Conversation < ApplicationRecord
    
    #if nothing is found, create a conversation
    def Conversation.find_conversation(user1, user2)
        @conversations1 = Recipient.where(user_id: user1.id)
        @conversations2 = Recipient.where(user_id: user2.id)
        
        for i in 0...@conversations1.length do
            for j in 0...@conversations2.length do
                if @conversations1[i].conversation_id == @conversations2[j].conversation_id
                    return Conversation.find(@conversations1[i].conversation_id)
                end
            end
        end
        
        return nil
    end
    
    def Conversation.create_between(user1, user2)
        @con = Conversation.create
        @con.add_user(user1)
        @con.add_user(user2)
        
        return @con
    end
    
    def add_user(user1)
       Recipient.create(user_id: user1.id, conversation_id: self.id) 
    end
    
    def remove_user(user1)
        @r = Recipient.find_by_user_id_and_conversation_id(user1.id, self.id)
        if @r then Recipient.destroy(@r.id) end
    end
    
    def send_message(user1, body)
        if !is_member?(user1)
            return nil
        end
        @msg = Message.new(sender_id: user1.id, conversation_id: self.id, body: body)
        
        if !@msg.save then return nil end
        
        return @msg
    end
    
    def get_users
        @rec = Recipient.where(conversation_id: self.id)
        
        @users = []
        @rec.each do |r|
            @users << User.find(r.user_id)
        end
        
        return @users
    end
    
    def get_members
        return get_users
    end
    
    def is_member?(user1)
        
        get_users.each do |user2|
            if user1.id == user2.id then return true end
        end
        
        return false
        
    end
    
    def get_messages
       @messages = Message.where(conversation_id: self.id)
       return @messages
    end
    
    def seen_by(id)
       @notifs = Notification.where(user_id: id, conversation_id: self.id)
       
       @notifs.each do |notif|
           notif.seen = true
           notif.save
       end
        
    end
end
