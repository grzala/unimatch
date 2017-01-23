class Event < ApplicationRecord
    belongs_to :society
    belongs_to :user
    belongs_to :event_group
end
