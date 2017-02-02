class CreateMessages < ActiveRecord::Migration[5.0]
  def change
    create_table :messages do |t|
        t.text :body
        t.boolean :read, :default => false
        
        t.integer :sender_id
        t.integer :recipient_id
      t.timestamps
    end
  end
end
