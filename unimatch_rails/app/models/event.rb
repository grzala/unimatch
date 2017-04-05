class Event < ApplicationRecord
    
    include Rails.application.routes.url_helpers
    
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
    
    def get_invited
        ei = EventInvite.where(event_id: self.id)
        invited = []
        ei.each do |i|
            invited << User.find(i.recipient_id)
        end
        return invited
    end
    
    def invite(sender, receiver)
        EventInvite.create(sender: sender, recipient: receiver, event_id: self.id)
        receiver.notify(event_path(:id => self.id), 'event invite', sender.id, "E")
    end   
    
    def self.search(string)
        toreturn = []
        words = string.split(" ")
        
        first_priority = []
        words.each do |word|  
            query = "(name LIKE '% #{word} %')"
            query += " OR (name LIKE '#{word} %')"
            query += " OR (name LIKE '% #{word}')"
            query += " OR (name LIKE '#{word}')"
            first_priority += Event.where(query)
        end
        first_priority = first_priority.compact.uniq
        
        second_priority = []
        words.each do |word| 
            query = "(description LIKE '% #{word} %')"
            query += " OR (description LIKE '#{word} %')"
            query += " OR (description LIKE '% #{word}')"
            query += " OR (description LIKE '#{word}')"
            second_priority += Event.where(query)
        end
        second_priority = second_priority.compact.uniq
        
        second_priority -= first_priority
        
        toreturn = [first_priority, second_priority]
        
        return toreturn
    end
    
    def self.get_events_attended_by(id)
		ep = Participant.where(user_id: id)
		events = []
		ep.each do |participant|
		    events << Event.find(participant.event_id)
		end
		return events
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
