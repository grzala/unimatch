class Notification < ApplicationRecord
    
    def prepare
        temp_dic = {}
        temp_dic['seen'] = self.seen
        temp_dic['sender'] = User.find(self.sender.to_i).name + " " + User.find(self.sender.to_i).surname
        temp_dic['link'] = self.link
        temp_dic['information'] = "New Message"
        temp_dic['image_url'] = User.find(self.sender.to_i).avatar_url(:display)
        return temp_dic
    end
end
