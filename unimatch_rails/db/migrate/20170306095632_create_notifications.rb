class CreateNotifications < ActiveRecord::Migration[5.0]
  def change
    create_table :notifications do |t|
      
      t.string :link
      t.string :information
      
      t.belongs_to :user
      t.belongs_to :conversation, :null => true
      
      t.boolean :seen, :default => false
      

      t.timestamps
    end
  end
end
