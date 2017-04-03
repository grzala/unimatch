class User < ApplicationRecord
	include Connect
    include Rails.application.routes.url_helpers
	
	extend FriendlyId
	friendly_id :name, use: [:slugged, :history]
	has_many :messages
	has_many :members
	has_many :societies, :through => :members
	has_many :participants
	has_many :events, :through => :participants
	
	has_one :university
	
	has_many :interests
	has_many :interests, :through => :user_interests
	#user model, the most important one, user has mesages, interest, a university, users email has to be unique, but two users can have the same name
	#validates pasword
	validates :name, :presence => true, :uniqueness => false, length: {maximum: 50}
	validates :password, confirmation: true, presence: true,
                       length: { minimum: 4 }, on: :create
	validates_confirmation_of :password, :message => "should match confirmation"
	VALID_EMAIL_REGEX = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+ac.uk)\z/i
	validates :email, :presence => true, :uniqueness => {:case_sensitive => false}, format: { with: VALID_EMAIL_REGEX }, length: {maximum: 255}
	attr_accessor :password, :password_confirmation
	
	IMPORTANT_INTERESTS_NO ||= 5

	mount_uploader :avatar, AvatarUploader

	
	def User.encrypt_password(password, salt)
		Digest::SHA2.hexdigest(password + "wibble" + salt)
	end

	#def should_generate_new_friendly_id?
    #	new_record?
	#end

	
	def password=(password)
		@password = password
		
		if password.present?
			generate_salt
			self.hashed_password = self.class.encrypt_password(password, salt)
		end
	end#used to generate salt on the password
	
	def User.authenticate(email, password)
		if user = find_by_email(email)
			if user.hashed_password == encrypt_password(password, user.salt)
				return user
			end
		end
	end#used for login, to authenticate the user
	
	def get_interests
		@ui = UserInterest.where(user_id: self.id)
		@interests = []
		@ui.each do |u|
			@interests << Interest.find_by_id(u.interest_id)
		end
		

		return @interests
	end#returns the interests of a user
	
	def get_important_interests
		@ii = UserInterest.where(user_id: self.id, important: true)
		@interests = []
		@ii.each do |i|
			@interests << Interest.find_by_id(i.interest_id)
		end
		return @interests
	end#returns the important interests of the user (the top 5)
	
	def get_interests_by_id
		@interests = get_interests
		@interest_ids = []
		@interests.each do |interest|
			@interest_ids << interest.id
		end
		
		return @interest_ids
	end#returns ids of the interests
	
	def update_interests_by_ids(interest_ids)
		@ui = UserInterest.where(user_id: self.id)
		@ui.each do |u|
			u.destroy
		end
		
		interest_ids.each do |interest_id|
			self.add_interest(interest_id)
		end
		
	end#when user changes his interests, it destroys the old ones and saves the new ones
	
	def refresh_matches
		Connector.refresh_matches(self.id)	
	end
	
	def get_matches(type)
		return Reccomendation.where(user_id: self.id, match_type: type)
	end
	
	def get_matched_users
		recs = get_matches("U")
		users = {}
		recs.each do |rec|
			users[rec.match_id] = rec.coefficient
		end
		return users
	end
	
	def get_matched_societies
		recs = get_matches("S")
		users = {}
		recs.each do |rec|
			users[rec.match_id] = rec.coefficient
		end
		return users
	end
	
	def get_match(id, type)
		match = Reccomendation.where(user_id: self.id, match_id: id, match_type: type)[0]
		
		if match.nil?
			if type == "U"
				Connector.match_against_user(self.id, id)
			elsif type == "S"
				Connector.match_against_society(self.id, id)
			end
		end
		
		match = Reccomendation.where(user_id: self.id, match_id: id, match_type: type)[0]
		
		return match
	end
	
	def get_interest_names
		@interests = self.get_interests
		@new = []
		@interests.each do |i|
			@new << i.name
		end
		return @new
	end#returns names of the interests
	
	def User.get_common_interests(usr1, usr2, important = false)
		usr1i = []
		usr2i = []
		
		if !important
			usr1i = usr1.get_interests
			usr2i = usr2.get_interests
		else
			usr1i = usr1.get_important_interests
			usr2i = usr2.get_important_interests
		end
		
		common = []
		usr1i.each do |i|
			if usr2i.include? i
				common << i
			end
		end
		return common
	end#used for displaying matches, returns common interests between two users
	
	def User.get_common_interests_fixed(usr1, usr2, len)
		important_list = User.get_common_interests(usr1, usr2, important = true)
		list = User.get_common_interests(usr1, usr2)
		
		lists = [important_list, list]
		l_i = 0
		cur_list = lists[l_i]
		
		i = 0
		toreturn = []
		while toreturn.length < len and i < len do
			if i >= cur_list.length
				l_i += 1
				i = 0
				if l_i >= lists.length
					break
				end
				cur_list = lists[i]
			end
			if !toreturn.include? cur_list[i]
				toreturn << cur_list[i]
			end
			i += 1
		end
		
		toreturn = toreturn.compact
		
		return toreturn
	end#does the same thing as the function above, just take one more input, which is the number of comon intererst to return
	
	#if less than 5 important, add as important
	def add_interest(id)
		@interests = get_interests_by_id
		if !@interests.include? id
			@ui = UserInterest.new(user_id: self.id, interest_id: id)
			if get_important_interests.length < IMPORTANT_INTERESTS_NO then @ui.important = true end
			@ui.save
		end
	end#add interest to user
	
	def delete_interest(id)
		@ui = UserInterest.find_by_user_id_and_interest_id(self.id, id)
		UserInterest.destroy(@ui.id)
	end#deletes interest from user
	
	def get_administered_societies
		@societies = []
		Member.where(user_id: self.id, admin: true).each do |member|
			@societies << Society.find(member.society_id)
		end
		return @societies
	end#returns the societies of which the user is admin
	
	def get_societies_ids
		members = Member.where(user_id: self.id)
		soc_ids = []
		members.each do |member|
			soc_ids << member.society_id
		end
		return soc_ids
	end#returns the societies ids of which the user is member
	
	def get_societies
		soc_ids = get_societies_ids
		socs = []
		soc_ids.each do |id|
			socs << Society.find(id)
		end
		return socs
	end#returns the societies of which the user is member
	
	def get_events_ids
		participants= Participant.where(user_id: self.id)
		ev_ids = []
		participants.each do |par|
			ev_ids << par.event_id
		end
		return ev_ids
	end#returns the event ids of which the user is participant
	
	def get_events
		ev_ids = get_events_ids
		evs = []
		ev_ids.each do |stuff|
			evs << Event.find(stuff)
		end
		return evs
	end#returns the event of which the user is participant
			
	
	def get_user_events
		allevents = Event.all
		userevents = []
		allevents.each do |ev|
			if ev.has_participant(id) == true 
				userevents << ev
			end
		end
		return userevents
		
	end#returns events on which the user participates
	
	def get_society_current_events
		societies = get_societies
		events = []
		societies.each do |soc|
			events += soc.get_current_events
		end
		return events
	end#returns current events of societies
	
	def get_notifications
		@notifs = Notification.where(user_id: self.id)
		return @notifs
	end#returns notificaties
	
	def notify(link, info, sender_id, type, special_id = nil)
		
		#if conversation exists, just one notification is needed. this prevents an overflow of notifications
		if special_id != nil and type == "M"
			@notifs = Notification.where(user_id: self.id, conversation_id: special_id)
			@notifs.each {|notif| Notification.destroy(notif.id) }
		elsif type == "F"
			@notifs = Notification.where(user_id: self.id, sender: sender_id)
			@notifs.each {|notif| Notification.destroy(notif.id) }
		end
		
		@notification = Notification.new
		@notification.link = link
		@notification.sender = sender_id
		@notification.information = info
		@notification.user_id = self.id
		@notification.conversation_id = special_id
		@notification.notif_type = type
		@notification.save
		
		notif = Notification.find(@notification.id)
		
        notif = notif.prepare
        
        notif = notif.to_json.html_safe
		
    	ActionCable.server.broadcast "notification_channel_#{self.id}", {notification: notif}
	end
	
	def get_favourites
		fu = FavouriteUser.where(user: self)
		users = []
		fu.each do |f|
			users << User.find(f.favourite.id)
		end
		return users
	end
	
	def add_favourite(user2)
		FavouriteUser.create(user: self, favourite: user2)
        user2.notify(user_path(:id => self.id), 'add to favourites', self.id, "F")
	end
	
	def remove_favourite(user2)
		fu = FavouriteUser.where(user: self, favourite: user2)
		fu.each {|f| f.destroy}
	end
	
	def self.search(string)
		toreturn = []
		words = string.split(" ")
		
		first_priority = []
		(0...words.length).to_a.combination(2).to_a.each do |combination|
			first_priority += User.where("name LIKE ? AND surname LIKE ?", words[combination[0]], words[combination[1]])
			first_priority += User.where("name LIKE ? AND surname LIKE ?", words[combination[1]], words[combination[0]])
		end
		first_priority = first_priority.compact.uniq
		
		second_priority = []
		words.each do |word| 
			second_priority += User.where("name LIKE ? OR surname LIKE ?", word, word)
		end
		second_priority = second_priority.compact.uniq
		
		second_priority -= first_priority
		
		toreturn = [first_priority, second_priority]
		
		return toreturn
		
	end
	
	private ############################# private methods below ##################################
	
	def password_must_be_present
		errors.add(:password, "Missing Password") unless hashed_password.present?
	end
	
	def generate_salt
		self.salt = self.object_id.to_s + rand.to_s
	end	#private methods for security
end
