class CreateRecipients < ActiveRecord::Migration[5.0]
  def change
    create_table :recipients do |t|
      
      t.belongs_to :user, :null => false
      t.belongs_to :conversation, :null => false

      t.timestamps
    end
  end
end
