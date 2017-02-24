class CreateParticipants < ActiveRecord::Migration[5.0]
  def change
    create_table :participants do |t|

      t.timestamps
      
      t.belongs_to :user, :null => false
      t.belongs_to :event, :null => false
    end
  end
end
