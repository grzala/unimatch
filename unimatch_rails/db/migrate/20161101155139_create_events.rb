class CreateEvents < ActiveRecord::Migration[5.0]
  def change
    create_table :events do |t|
      t.string :name
      t.date :date
      t.time :time
      t.string :description
      t.string :location
      t.boolean :fixed
      t.boolean :frequency
      t.float :cost
      
      t.belongs_to :society
      
      t.timestamps
    end
  end
end
