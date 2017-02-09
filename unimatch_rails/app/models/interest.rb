class Interest < ApplicationRecord
    belongs_to :interest_group

    has_many :users
    has_many :users, :through => :user_interests
    
    has_many :societies
    has_many :societies, :through => :society_interests
    
    validates :name, :presence => true, :uniqueness => {:case_sensitive => false}
    
    
    def self.retrieve_as_dictionary
       toreturn = {}
       @interest_groups = InterestGroup.all
       
       @interest_groups.each do |ig|
          interests = Interest.where(interest_group_id: ig.id)  
          toreturn[ig] = interests
       end
       
       return toreturn
    end
    
end
