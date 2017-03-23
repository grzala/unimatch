class Member < ApplicationRecord
    belongs_to :user
    belongs_to :society
end
#used as a middleware between the user and a society, user becomes a part of society as a member