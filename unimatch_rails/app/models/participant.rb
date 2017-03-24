class Participant < ApplicationRecord
    belongs_to :user
    belongs_to :event
end
#when user clicks that he will attend a event he becomes a participant of this event