class SocietyInterest < ApplicationRecord
    belongs_to :society
    belongs_to :interest
end
#used to assign interests to societies