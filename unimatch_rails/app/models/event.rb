class Event < ApplicationRecord
    belongs_to :user
    
    def get_owner_name
       
        if (self.society_id != nil)
            return Society.find(self.society_id).name
        else
            return User.find(self.user_id).name
        end
        
    end
    
end
