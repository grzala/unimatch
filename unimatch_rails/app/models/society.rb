class Society < ApplicationRecord
  has_many :users
  has_many :users, :through => :members
  
  has_many :events
  has_many :billing_history
  
  validates :name, :presence => true, :uniqueness => {:case_sensitive => false}, length: {maximum: 50}
  
  def get_members
		@sm = Member.where(society_id: self.id)
		@users = []
		@sm.each do |m|
			@users << User.find_by_id(m.user_id)
		end
		return @users
  end
  
  def get_members_by_id
    return filter_by_id(get_members)   
  end
  
  def add_member(id)
    
		@members = get_members_by_id
		if !@members.include? id
			Member.create(user_id: id, society_id: self.id)
		end
  end
  
  def delete_member(id)
    @m = Member.find_by_society_id_and_user_id(self.id, id) #not using .where method as just 1 record is expected to be found
    if @m != nil and !@m.admin then @m.destroy end
  end
  
  def get_admins
		@sm = Member.where(society_id: self.id)
		@admins = []
		@sm.each do |m|
		  #if is an admin, add to array
		  if m.admin then @admins << User.find_by_id(m.user_id) end
		end
		return @admins
  end
  
  def get_admins_by_id
    return filter_by_id(get_admins)
  end
  
  def add_admin(id)
    if !get_members_by_id.include? id then return end #can't grant privileges if not a member
    
    @m = Member.find_by_society_id_and_user_id(self.id, id)
    @m.admin = true
    @m.save
  end
  
  def delete_admin(id)
    @m = Member.find_by_society_id_and_user_id(self.id, id)
    if @m == nil then return end
    
    if @m.admin 
      @m.admin = false
      @m.save
    end
  end
  
  def has_member(id)
    return get_members_by_id.include? id
  end
  
  def has_admin(id)
    return get_admins_by_id.include? id
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
