class Conversation < ApplicationRecord
    belongs_to :user, :foreign_key => :sender_id
    belongs_to :user, :foreign_key => :recipient_id
    
    has_many :messages, dependent: :destroy
    
    validates_uniqueness_of :sender_id, :scope => :recipient_id
end