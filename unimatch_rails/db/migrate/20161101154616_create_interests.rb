class CreateInterests < ActiveRecord::Migration[5.0]
  def change
    create_table :interests do |t|
      t.belongs_to :interest_group
      t.string :name
      
      t.timestamps
    end
  end
end
