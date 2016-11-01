class CreateUserInterests < ActiveRecord::Migration[5.0]
  def change
    create_table :user_interests do |t|
      
      t.belongs_to :user
      t.belongs_to :interest

      t.timestamps
    end
  end
end
