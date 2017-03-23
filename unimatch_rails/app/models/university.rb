class University < ApplicationRecord
    belongs_to :user
end
#this would be used if we were to expand, for now we dont need it as all the users are from UoA