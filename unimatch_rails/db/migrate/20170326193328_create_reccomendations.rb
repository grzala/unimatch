class CreateReccomendations < ActiveRecord::Migration[5.0]
  def change
    create_table :reccomendations do |t|

	t.belongs_to :user
	t.string :match_type, limit: 1
	t.integer :match_id
	t.float :coefficient	
	
      t.timestamps
    end
  end
end
