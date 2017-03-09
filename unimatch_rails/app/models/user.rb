class User < ApplicationRecord
	has_many :messages
	has_many :members
	has_many :societies, :through => :members
	has_many :participants
	has_many :events, :through => :participants
	
	has_one :university
	
	has_many :interests
	has_many :interests, :through => :user_interests
	
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
	
	
	def mailboxer_email(object)
 
		return email

	end

	
	def password=(password)
		@password = password
		
		if password.present?
			generate_salt
			self.hashed_password = self.class.encrypt_password(password, salt)
		end
	end
	
	def User.authenticate(email, password)
		if user = find_by_email(email)
			if user.hashed_password == encrypt_password(password, user.salt)
				return user
			end
		end
	end
	
	def get_interests
		@ui = UserInterest.where(user_id: self.id)
		@interests = []
		@ui.each do |u|
			@interests << Interest.find_by_id(u.interest_id)
		end
		return @interests
	end
	
	def get_important_interests
		@ii = UserInterest.where(user_id: self.id, important: true)
		@interests = []
		@ii.each do |i|
			@interests << Interest.find_by_id(i.interest_id)
		end
		return @interests
	end
	
	def get_interests_by_id
		@interests = get_interests
		@interest_ids = []
		@interests.each do |interest|
			@interest_ids << interest.id
		end
		
		return @interest_ids
	end
	
	def update_interests_by_ids(interest_ids)
		@ui = UserInterest.where(user_id: self.id)
		@ui.each do |u|
			u.destroy
		end
		
		interest_ids.each do |interest_id|
			self.add_interest(interest_id)
		end
		
	end
	
	def get_interest_names
		@interests = self.get_interests
		@new = []
		@interests.each do |i|
			@new << i.name
		end
		return @new
	end
	
	#if less than 5 important, add as important
	def add_interest(id)
		@interests = get_interests_by_id
		if !@interests.include? id
			@ui = UserInterest.new(user_id: self.id, interest_id: id)
			if get_important_interests.length < IMPORTANT_INTERESTS_NO then @ui.important = true end
			@ui.save
		end
	end
	
	def delete_interest(id)
		@ui = UserInterest.find_by_user_id_and_interest_id(self.id, id)
		UserInterest.destroy(@ui.id)
	end
	
	def get_administered_societies
		@societies = []
		Member.where(user_id: self.id, admin: true).each do |member|
			@societies << Society.find(member.society_id)
		end
		return @societies
	end
	
	def get_societies_ids
		members = Member.where(user_id: self.id)
		soc_ids = []
		members.each do |member|
			soc_ids << member.society_id
		end
		return soc_ids
	end
	
	def get_societies
		soc_ids = get_societies_ids
		socs = []
		soc_ids.each do |id|
			socs << Society.find(id)
		end
		return socs
	end
	
	def get_events_ids
		participants= Participant.where(user_id: self.id)
		ev_ids = []
		participants.each do |par|
			ev_ids << par.event_id
		end
		return ev_ids
	end
	
	def get_events
		ev_ids = get_events_ids
		evs = []
		ev_ids.each do |stuff|
			evs << Event.find(stuff)
		end
		return evs
	end
			
	
	def get_user_events
		allevents = Event.all
		userevents = []
		allevents.each do |ev|
			if ev.has_participant(id) == true 
				userevents << ev
			end
		end
		return userevents
		
	end
	
	def get_society_current_events
		societies = get_societies
		events = []
		societies.each do |soc|
			events += soc.get_current_events
		end
		return events
	end
	
	def get_notifications
		@notifs = Notification.where(user_id: self.id)
		return @notifs
	end
	
	def notify(link, info, con_id = nil)
		
		#if conversation exists, just one notification is needed. this prevents an overflow of notifications
		if con_id != nil
			@notifs = Notification.where(user_id: self.id, conversation_id: con_id)
			@notifs.each {|notif| Notification.destroy(notif.id) }
		end
		
		@notification = Notification.new
		@notification.link = link
		@notification.information = info
		@notification.user_id = self.id
		@notification.conversation_id = con_id
		@notification.save
		
		
    	ActionCable.server.broadcast "notification_channel_#{self.id}", {notification: Notification.find(@notification.id).to_json.html_safe}
	end
	
	private ############################# private methods below ##################################
	
	def password_must_be_present
		errors.add(:password, "Missing Password") unless hashed_password.present?
	end
	
	def generate_salt
		self.salt = self.object_id.to_s + rand.to_s
	end	
end
