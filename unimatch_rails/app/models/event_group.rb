class EventGroup < ApplicationRecord
    has_many :events
end
#event groups are used for reccuring events