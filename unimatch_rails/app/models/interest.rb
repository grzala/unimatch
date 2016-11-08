class Interest < ApplicationRecord
    belongs_to :interest_group

    has_many :users
    has_many :users, :through => :user_interests
end
