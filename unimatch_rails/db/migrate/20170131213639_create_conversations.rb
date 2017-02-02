class CreateConversations < ActiveRecord::Migration[5.0]
  def change
    create_table :conversations do |t|
        #t.integer :conversation_id
        t.integer :sender_id
        t.integer :recipient_id
        #t.boolean :already , :default => false
        t.timestamps
    end
  end
end
