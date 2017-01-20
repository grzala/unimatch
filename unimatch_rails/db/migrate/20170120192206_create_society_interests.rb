class CreateSocietyInterests < ActiveRecord::Migration[5.0]
  def change
    create_table :society_interests do |t|
     
      t.belongs_to :society
      t.belongs_to :interest
      
      t.timestamps
    end
  end
end
