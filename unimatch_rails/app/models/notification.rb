class Notification < ApplicationRecord
    # types
    # F - favorite
    # M - message
    # E - event invite
    

    
    def prepare
        temp_dic = {}
        temp_dic['id'] = self.id
        temp_dic['seen'] = self.seen
        temp_dic['sender'] = User.find(self.sender.to_i).name + " " + User.find(self.sender.to_i).surname
        temp_dic['link'] = self.link
        temp_dic['information'] = "Unknown notification"
        temp_dic['conversation_id'] = self.conversation_id
        
        
        if self.notif_type == "M"
            temp_dic['information'] = "New Message"
            temp_dic['image_url'] = User.find(self.sender.to_i).avatar_url(:display)
        elsif self.notif_type == "E"
            temp_dic['information'] = "Event Invite"
            temp_dic['image_url'] = User.find(self.sender.to_i).avatar_url(:display)
        elsif self.notif_type == "F"
            temp_dic['information'] = "Added you to favourites"
            temp_dic['image_url'] = User.find(self.sender.to_i).avatar_url(:display)
        end
        
        

        return temp_dic
    end
end
