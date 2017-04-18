class InterestGroup < ApplicationRecord
    has_many :interests
    
    def get_interests
        return Interest.where(interest_group_id: id)
    end
    
end
