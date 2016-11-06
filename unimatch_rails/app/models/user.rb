class User < ApplicationRecord
  has_many :members
  has_many :societies, :through => :members
  
  has_one :university
  
  has_many :interests
  has_many :interests, :through => :user_interests
  
  validates :name, :presence => true, :uniqueness => true, length: {maximum: 50}
  VALID_EMAIL_REGEX = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+ac.uk)\z/i
  validates :email, :presence => true, :uniqueness => {case_sensitive: false}, format: { with: VALID_EMAIL_REGEX }, length: {maximum: 255}
  
  def User.encrypt_password(password, salt)
    Digest::SHA2.hexdigest(password + "wibble" + salt)
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
	
	private
	
	def password_must_be_present
		errors.add(:password, "Missing Password") unless hashed_password.present?
	end
	
	def generate_salt
		self.salt = self.object_id.to_s + rand.to_s
	end	
end
