class User < ApplicationRecord
  has_many :members
  has_many :societies, :through => :members
  
  has_one :university
  
  has_many :interests
  has_many :interests, :through => :user_interests
  
  validates :name, :presence => true, :uniqueness => true, length: {maximum: 50}
  VALID_EMAIL_REGEX = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+ac.uk)\z/i
  validates :email, :presence => true, :uniqueness => {case_sensitive: false}, format: { with: VALID_EMAIL_REGEX }, length: {maximum: 255}
end
