class Event < ApplicationRecord
    #event model, used for basic event functions
    belongs_to :user
    
    has_many :users
    has_many :users, :through => :participants
    
    def get_owner_name
       
        if (self.society_id != nil)
            return Society.find(self.society_id).name
        else
            return User.find(self.user_id).name
        end
        
    end#returns the 'owner' of the event, either a user or a society
    
    def get_participants
		@ep = Participant.where(event_id: self.id)
		@participants = []
		@ep.each do |m|
			@participants << User.find_by_id(m.user_id)
		end
		return @participants
    end#returns all the people that will participate on the event
    
    
    
    def get_participants_by_id
        return filter_by_id(get_participants)   
    end
    
    def add_participant(id)
		@participants = get_participants_by_id
		if !@participants.include? id
			Participant.create(user_id: id, event_id: self.id)
		end
    end#add a participant to a event
    
    def delete_participant(id)
        @p = Participant.find_by_event_id_and_user_id(self.id, id) #not using .where method as just 1 record is expected to be found
        if @p != nil then @p.destroy end
    end#when user doesnt wanto attend the event anymore
    
    def has_participant(id)
        return get_participants_by_id.include? id
    end
    
    private
    def filter_by_id(array)
        @ids = []
        array.each do |item|
            @ids << item.id
        end
        return @ids    
    end

end
