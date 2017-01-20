class CreateMembers < ActiveRecord::Migration[5.0]
  def change
    create_table :members do |t|

      t.timestamps
      
      t.belongs_to :user, :null => false
      t.belongs_to :society, :null => false
      t.boolean :admin, :default => false
    end
  end
end
