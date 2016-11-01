class Society < ApplicationRecord
  has_many :users
  has_many :users, :through => :members
  
  has_many :events
  has_many :billing_history
end
