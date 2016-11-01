class Interest < ApplicationRecord
    has_one :interest_group

    has_many :users
    has_many :users, :through => :user_interests
end
