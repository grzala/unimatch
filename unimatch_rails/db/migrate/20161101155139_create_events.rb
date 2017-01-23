class CreateEvents < ActiveRecord::Migration[5.0]
  def change
    create_table :events do |t|
      t.string :name
      t.date :startdate
      t.date :enddate
      t.integer :time
      t.string :description
      t.string :location
      t.integer :frequency, :default => 0
      t.float :cost, :default => 0.0
      t.boolean :canceled, :default => false
      
      t.belongs_to :society, :default => nil, :null => true
      t.belongs_to :user
      t.belongs_to :event_group, :default => nil, :null => true
      
      t.timestamps
    end
  end
end
