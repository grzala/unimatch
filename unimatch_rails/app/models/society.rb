class Society < ApplicationRecord
  #used for all societies, societies have users and events, it is prepared for the billing history to be implented, it checks if the name of the society is unique, so we dont have two 
  #societies with the same name
  
  has_many :users
  has_many :users, :through => :members
  
  has_many :events
  has_many :billing_history
  
  has_many :interests
  has_many :interests, :through => :society_interests
  
  validates :name, :presence => true, :uniqueness => {:case_sensitive => false}, length: {maximum: 50}
  
  mount_uploader :avatar, AvatarUploader
  
  def get_members
		@sm = Member.where(society_id: self.id)
		@users = []
		@sm.each do |m|
			@users << User.find_by_id(m.user_id)
		end
		return @users
  end#return the members of given society
  
  def get_members_by_id
    return filter_by_id(get_members)   
  end
  
  def add_member(id)
		@members = get_members_by_id
		if !@members.include? id
			Member.create(user_id: id, society_id: self.id)
		end
  end#add a member to a society, executes when user clicks join society
  
  def delete_member(id)
    @m = Member.find_by_society_id_and_user_id(self.id, id) #not using .where method as just 1 record is expected to be found
    if @m != nil and !@m.admin then @m.destroy end
  end#deletes user from a society, executes when user clicks leave a society
  
  def get_admins
		@sm = Member.where(society_id: self.id)
		@admins = []
		@sm.each do |m|
		  #if is an admin, add to array
		  if m.admin then @admins << User.find_by_id(m.user_id) end
		end
		return @admins
  end#returns all the admins of given society
  
  def get_admins_by_id
    return filter_by_id(get_admins)
  end
  
  def add_admin(id)
    if !get_members_by_id.include? id then return end #can't grant privileges if not a member
    
    @m = Member.find_by_society_id_and_user_id(self.id, id)
    @m.admin = true
    @m.save
  end#add user as a admin
  
  def delete_admin(id)
    @m = Member.find_by_society_id_and_user_id(self.id, id)
    if @m == nil then return end
    
    if @m.admin 
      @m.admin = false
      @m.save
    end
  end#deletes admin, and user will be just a member
  
  def has_member(id)
    return get_members_by_id.include? id
  end#to check if a given user is a member of given society you call this function on
  
  def has_admin(id)
    return get_admins_by_id.include? id
  end#to check if a given user is an admin of given society you call this function on
  
  def add_interest(id)
    SocietyInterest.create(society_id: self.id, interest_id: id)
  end#add intersts to a society
  
  def get_interests
		@si = SocietyInterest.where(society_id: self.id)
		@interests = []
		@si.each do |s|
			@interests << Interest.find_by_id(s.interest_id)
		end
		return @interests
  end#returns all the interests of given society
  
  def get_interests_by_id
    return filter_by_id(get_interests)
  end
  
  def get_interests_by_name
    return filter_by_name(get_interests)
  end
  
  def get_events
    return Event.where(society_id: self.id)
  end#returns all the events which have given societies id, this is how you check for events for whatever society
  
  def get_current_events
    events = get_events
    current_events = []
    
    events.each do |event| 
      if event.date > DateTime.now and event.date < DateTime.now + 2.months
        current_events << event
      end
    end
    
    return current_events
  end#returns event that have yet to happen
  
  private
  def filter_by_id(array)
    @ids = []
    array.each do |item|
      @ids << item.id
    end
    return @ids    
  end
  
  def filter_by_name(array)
    @ids = []
    array = array.compact
    array.each do |item|
      @ids << item.name
    end
    return @ids    
  end#private methods for security
  
  def self.search(string)
    toreturn = []
    words = string.split(" ")
    
    first_priority = []
    words.each do |word| 
      query = "(name LIKE '% #{word} %')"
      query += " OR (name LIKE '#{word} %')"
      query += " OR (name LIKE '% #{word}')"
      query += " OR (name LIKE '#{word}')"
      
      first_priority += Society.where(query)
    end
    first_priority = first_priority.compact.uniq
    
    second_priority = []
    words.each do |word| 
      query = "(description LIKE '% #{word} %')"
      query += " OR (description LIKE '#{word} %')"
      query += " OR (description LIKE '% #{word}')"
      query += " OR (description LIKE '#{word}')"
      
      second_priority += Society.where(query)
    end
    second_priority = second_priority.compact.uniq
    
    second_priority -= first_priority
    
    toreturn = [first_priority, second_priority]
    
    return toreturn
  end
  
end
