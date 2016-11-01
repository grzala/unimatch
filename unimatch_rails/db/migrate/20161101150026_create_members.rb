class CreateMembers < ActiveRecord::Migration[5.0]
  def change
    create_table :members do |t|

      t.timestamps
      
      t.belongs_to :user
      t.belongs_to :society
      t.boolean :admin, :default => false
    end
  end
end
